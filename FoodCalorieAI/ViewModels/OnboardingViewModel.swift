//
//  OnboardingViewModel.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 14.03.2026.
//

import Foundation

struct OnboardingItem {
    let imgName: String
    let title: String
    let subTitle: String
}


class OnboardingViewModel: ObservableObject {
    
    @Published var onbItems: [OnboardingItem] = [OnboardingItem(imgName: "IMG1", title: "Scan your meals \ninstantly", subTitle: "Get calories and ingredients \nwith one photo"),
                                             OnboardingItem(imgName: "IMG2", title: "Track your nutrition \ndaily", subTitle: "Log meals and monitor \nyour calorie goal"),
                                             OnboardingItem(imgName: "IMG3", title: "Get smarter food \nrecommendations", subTitle: "Discover healthier swaps \npowered by AI")]
    
    
    @Published var currentIndex: Int = 0
    @Published var showPaywall = false
    @Published var showOnboarding = true
    
    
}
