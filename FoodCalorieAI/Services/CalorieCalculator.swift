//
//  CalorieCalculator.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 01.08.2025.
//


class CalorieCalculator {
    static func calculateCalorieNeeds(weightKg: Double,
                                      heightCm: Double,
                                      age: Int,
                                      gender: Gender,
                                      activityLevel: Double = 1.4,
                                      goal: Goal) -> Int {
        
        let bmr: Double
        if gender == .male {
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) + 5
        } else {
            bmr = 10 * weightKg + 6.25 * heightCm - 5 * Double(age) - 161
        }
        
        var calories = bmr * activityLevel
        
        switch goal {
        case .loseWeight:
            calories -= 300
        case .gainWeight:
            calories += 300
        case .maintainWeight:
            break
        }
        
        return Int(calories)
    }
}
