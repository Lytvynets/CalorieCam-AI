//
//  ReccomendationView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 08.03.2026.
//

import SwiftUI

struct RecommendationView: View {
    
    @EnvironmentObject private var openAI: OpenAIService
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            LiquidBackground()
                .navigationTitle("AI Reccomendation")
                .navigationBarTitleDisplayMode(.inline)
            
            ScrollView {
                if isLoading {
                    loadingIndicator
                }else{
                    recommendationInfo
                }
            }
            .scrollIndicators(.hidden)
            .padding()
        }
        .onAppear {
            isLoading = true
            openAI.getRecommendation(for: openAI.resultText) { recommendation in
                DispatchQueue.main.async {
                    openAI.recommendationText = recommendation ?? "Not to visit, not to recognize"
                    isLoading = false
                    print("AI порада: \(recommendation ?? "Немає відповіді")")
                }
            }
        }
    }
    
    
    private var loadingIndicator: some View {
        ProgressView()
            .scaleEffect(2)
            .tint(.white)
            .padding()
    }
    
    
    private var recommendationInfo: some View {
        VStack {
            Text("General insight:\n\n\(openAI.recommendationText)")
                .font(.system(size: AdaptiveFontSize.adaptive20, weight: .semibold, design: .rounded))
            
            VStack(spacing: 8) {
                
                Text("AI-generated nutrition estimate. Not medical advice. Consult a professional for personalized guidance.")
                
                Text("Nutritional estimates are based on publicly available data from trusted sources.")
                
                Text("Sources:")
                    .fontWeight(.semibold)
                    .padding(.top, 4)
                
                Link("USDA FoodData Central", destination: URL(string: "https://fdc.nal.usda.gov")!)
                
                Link("WHO Nutrition Guidelines", destination: URL(string: "https://www.who.int/health-topics/nutrition")!)
            }
            .font(.system(size: 15, weight: .light, design: .rounded))
            .multilineTextAlignment(.center)
            .padding(.top)
        }
    }
}

#Preview {
    RecommendationView()
        .environmentObject(OpenAIService())
}
