//
//  ResponseLanguageView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 12.03.2026.
//

import SwiftUI

struct ResponseLanguageView: View {
    
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            LiquidBackground()
                .navigationTitle("Response Language")
                .navigationBarTitleDisplayMode(.inline)
            
            ScrollView {
                VStack {
                    ForEach(settingsViewModel.languages) { language in
                        languageRow(language: language)
                            .onTapGesture {
                                UserDefaults.standard.set(language.name, forKey: "responseLanguages")
                                settingsViewModel.responseLanguage = language.name
                            }
                        Divider()
                            .background(.gray)
                    }
                }
            }
            .padding()
            .scrollIndicators(.hidden)
        }
    }
    
    
    private func languageRow(language: Language) -> some View {
        HStack(spacing: 15) {
            Image(settingsViewModel.responseLanguage == language.name ? "radio" : "radio_1")
            Text(language.flag)
                .font(.system(size: AdaptiveFontSize.adaptive32, weight: .regular, design: .rounded) )
            Text(language.name)
                .foregroundStyle(.white)
                .font(.system(size: AdaptiveFontSize.adaptive16, weight: .regular, design: .rounded) )
            Spacer()
        }
    }
}

#Preview {
    ResponseLanguageView()
}
