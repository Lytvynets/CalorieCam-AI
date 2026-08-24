//
//  OpenAIService.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 31.07.2025.
//

import Foundation
import UIKit

enum FoodAnalysisErrorWrapper: Error {
    case custom(String)
}

struct FoodAnalysisResult: Codable {
    let name: String
    let weightGrams: Double
    let calories: Double
    let protein: Double
    let fat: Double
    let carbs: Double
}


struct FoodAnalysisError: Codable {
    let error: String
}


enum ResponseLanguage {
    case english
    case ukrainian
    
    var promptLanguagePrefix: String {
        switch self {
        case .english:
            return ""
        case .ukrainian:
            return "Answer in Ukrainian.\n"
        }
    }
}


enum PortionSize: String {
    case small
    case medium
    case large
    
    var description: String {
        switch self {
        case .small: return "маленька (100–150 г)"
        case .medium: return "середня (250–300 г)"
        case .large: return "велика (400–500 г)"
        }
    }
}



class OpenAIService: ObservableObject {
    
    @Published var foodName = "Loading..."
    @Published var foodCalories = 0.0
    @Published var foodProtein = 0.0
    @Published var foodFat = 0.0
    @Published var foodCarbs = 0.0
    @Published var foodWeight = 0.0
    @Published var resultText = ""
    @Published var recommendationText = ""
    @Published var portionSize: PortionSize = .small
    @Published var showErrorAlert = false
    @Published var errorText = "Error"
    
    private let apiKey = "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"
    
    
    func analyzeFoodImage(_ image: UIImage, portionSize: PortionSize, setExactValue: Bool, exactValue: Double, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion("Не вдалося зчитати фото")
            showErrorAlert = true
            errorText = "Failed to read the photo. Make sure everything is clearly visible in the photo and try again."
            return
        }
        
        let responseLanguage = UserDefaults.standard.string(forKey: "responseLanguages") ?? "English"
        let base64Image = imageData.base64EncodedString()
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = """
        You are a professional nutritionist. A user has sent a food photo and selected a portion size: \( setExactValue ? "\(exactValue)" : portionSize.description).
        
        Just translate the result that comes into "name" into the language: \(responseLanguage).
        
        1. Identify the food shown in the photo.
        2. Estimate approximate **calories**, **fat**, **protein**, and **carbs** based on the selected portion.
        3. Reply strictly in JSON format:
        
        {
          "name": "...",
          "weightGrams": ...,
          "calories": ...,
          "protein": ...,
          "fat": ...,
          "carbs": ...
        }
        
        If you can't recognize the food, reply with:
        
        {
          "error": "Could not recognize the food"
        }
        
        Reply ONLY in JSON format, without explanations.
        """
        
        let messages: [[String: Any]] = [
            [
                "role": "system",
                "content": prompt
            ],
            [
                "role": "user",
                "content": [
                    [
                        "type": "image_url",
                        "image_url": [
                            "url": "data:image/jpeg;base64,\(base64Image)"
                        ]
                    ]
                ]
            ]
        ]
        
        let body: [String: Any] = [
            "model": "gpt-4o",
            "messages": messages,
            "max_tokens": 1000
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion("Помилка: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion("Дані не отримано")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let choices = json?["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content)
                    let result = self.decodeFoodAnalysis(from: content)
                    
                    switch result {
                    case .success(let food):
                        DispatchQueue.main.async {
                            self.foodName = food.name
                            self.foodCalories = food.calories
                            self.foodProtein = food.protein
                            self.foodFat = food.fat
                            self.foodCarbs = food.carbs
                            self.foodWeight = food.weightGrams
                        }
                        
                        print("🍽️ Name: \(food.name), Calories: \(food.calories)")
                    case .failure(let error):
                        print("⚠️ Error: \(error)")
                    }
                    
                } else if let jsonString = String(data: data, encoding: .utf8) {
                    print("❌ Unexpected response: \(jsonString)")
                    completion("Невідомий формат відповіді")
                } else {
                    completion("Не вдалося розпарсити відповідь")
                }
            } catch {
                completion("JSON помилка: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    
    func decodeFoodAnalysis(from content: String) -> Result<FoodAnalysisResult, Error> {
        
        let cleaned = content
            .replacingOccurrences(of: "'''json", with: "")
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "'''", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("Test json \(cleaned)")
        
        guard let contentData = cleaned.data(using: .utf8) else {
            return .failure(FoodAnalysisErrorWrapper.custom("Failed to encode response text"))
        }
        
        let decoder = JSONDecoder()
        
        if let result = try? decoder.decode(FoodAnalysisResult.self, from: contentData) {
            return .success(result)
        }
        
        if (try? decoder.decode(FoodAnalysisError.self, from: contentData)) != nil {
            DispatchQueue.main.async {
                self.showErrorAlert = true
                self.errorText = "Failed to read the photo. Make sure everything is clearly visible in the photo and try again."
            }
            return .failure( FoodAnalysisErrorWrapper.custom("Could not decode AI response"))
        }
        
        return .failure(FoodAnalysisErrorWrapper.custom("Could not decode AI response"))
    }
    
    
    func getRecommendation(for mealDescription: String, completion: @escaping (String?) -> Void) {
        let responseLanguage = UserDefaults.standard.string(forKey: "responseLanguages") ?? "English"

        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let messages: [[String: Any]] = [
            [
                "role": "system",
                "content": "You are an AI assistant that provides general informational nutrition insights based on publicly available data. Do not present yourself as a medical professional or expert. Do not give medical or personalized advice. Use neutral, educational language. Avoid phrases like 'you should', 'it is recommended for you', or 'you need to'. Instead, describe general characteristics of foods and common alternatives. Keep the answer short and informative. Respond in \(responseLanguage)."
            ],
            [
                "role": "user",
                "content": "Provide general nutritional information about this meal: \(mealDescription). Mention common alternative foods and briefly describe their typical nutritional differences."
            ]
        ]
        
        
        let body: [String: Any] = [
            "model": "gpt-4o",
            "messages": messages,
            "max_tokens": 500
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion("Помилка: \(error.localizedDescription)")
                self.showErrorAlert = true
                self.errorText = "Failed to read the photo. Make sure everything is clearly visible in the photo and try again."
                return
            }
            
            guard let data = data else {
                completion("Дані не отримано")
                self.showErrorAlert = true
                self.errorText = "Failed to read the photo. Make sure everything is clearly visible in the photo and try again."
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let choices = json?["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content)
                } else if let jsonString = String(data: data, encoding: .utf8) {
                    print("❌ Unexpected response: \(jsonString)")
                    completion("Невідомий формат відповіді")
                } else {
                    completion("Не вдалося розпарсити відповідь")
                }
            } catch {
                self.showErrorAlert = true
                self.errorText = "Failed to read the photo. Make sure everything is clearly visible in the photo and try again."
                completion("JSON помилка: \(error.localizedDescription)")
            }
        }.resume()
    }
}
