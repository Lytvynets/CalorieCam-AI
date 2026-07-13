//
//  ProfileViewModel.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 23.03.2026.
//

import Foundation

enum Gender: String {
    case male = "male"
    case female = "female"
}


enum Goal: String {
    case loseWeight = "lose Weight"
    case maintainWeight = "maintain Weight"
    case gainWeight = "gain Weight"
}


struct ActivityLevel {
    let lowActive = 1.2
    let midActive = 1.4
    let active = 1.6
    let heightActive = 1.8
}

class ProfileViewModel: ObservableObject {
    
    @Published var gender: Gender {
        didSet {
            UserDefaults.standard.set(gender.rawValue, forKey: "gender")
        }
    }
    
    @Published var goal: Goal {
        didSet {
            UserDefaults.standard.set(goal.rawValue, forKey: "goal")
        }
    }
    
    @Published var activityLevel: Double {
        didSet {
            UserDefaults.standard.set(activityLevel, forKey: "activityLevel")
        }
    }
    
    @Published var dailyCalories: Int? {
        didSet {
            UserDefaults.standard.set(dailyCalories, forKey: "dailyCalories")
        }
    }
    
    @Published var age: Int {
        didSet {
            UserDefaults.standard.set(age, forKey: "age")
        }
    }
    
    @Published var weight: Double {
        didSet {
            UserDefaults.standard.set(weight, forKey: "weight")
        }
    }
    
    @Published var height: Double {
        didSet {
            UserDefaults.standard.set(height, forKey: "height")
        }
    }
    
    
    init() {
        let gender = UserDefaults.standard.string(forKey: "gender")
        let goal = UserDefaults.standard.string(forKey: "goal")
        let age = UserDefaults.standard.object(forKey: "age") as? Int ?? 25
        let weight = UserDefaults.standard.object(forKey: "weight") as? Double ?? 75
        let height = UserDefaults.standard.object(forKey: "height") as? Double ?? 175
        let activityLevel = UserDefaults.standard.object(forKey: "activityLevel") as? Double ?? 1.2
        let dailyCalories = UserDefaults.standard.integer(forKey: "dailyCalories")
        
        self.gender = Gender(rawValue: gender ?? "") ?? .male
        self.goal = Goal(rawValue: goal ?? "") ?? .loseWeight
        self.age = age
        self.weight = weight
        self.height = height
        self.activityLevel = activityLevel
        self.dailyCalories = dailyCalories
    }
    
    
    func canTakePhoto() -> Bool {
        let defaults = UserDefaults.standard
        
        guard let lastDate = defaults.object(forKey: "lastPhotoDate") as? Date else {
            return true
        }
        
        return !Calendar.current.isDateInToday(lastDate)
    }
    
    
    func savePhotoDate() {
        UserDefaults.standard.set(Date(), forKey: "lastPhotoDate")
    }
    
}
