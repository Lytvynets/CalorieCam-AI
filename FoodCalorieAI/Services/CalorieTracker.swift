//
//  CalorieTracker.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 01.08.2025.
//

import Foundation

class CalorieTracker: ObservableObject {
    @Published var dailyCaloriesConsumed: Int = 0
    @Published var dailyCalorieLimit: Int = 2200

    func addCalories(_ amount: Int) {
        dailyCaloriesConsumed += amount
    }

    func resetForNewDay() {
        dailyCaloriesConsumed = 0
    }

    var remainingCalories: Int {
        max(dailyCalorieLimit - dailyCaloriesConsumed, 0)
    }

    var progress: Double {
        min(Double(dailyCaloriesConsumed) / Double(dailyCalorieLimit), 1.0)
    }
}
