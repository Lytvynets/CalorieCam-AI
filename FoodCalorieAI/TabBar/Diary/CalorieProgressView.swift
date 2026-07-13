//
//  CalorieProgressView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 15.03.2026.
//

import SwiftUI

struct CalorieProgressView: View {
    
    let currentCalories: Double
    let goalCalories: Double
    
    var progress: Double {
        min(currentCalories / goalCalories, 1)
    }
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 35)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color(hex: "#26B52F") ,
                    style: StrokeStyle(
                        lineWidth: 35,
                        lineCap: .square
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: progress)
            
            VStack(spacing: 4) {
                Text("\(Int(currentCalories))/")
                
                
                Text("\(Int(goalCalories))")
                
                Text("kcal")
                    .font(.custom("Inter-Black", size: AdaptiveFontSize.adaptive17))
                    .foregroundColor(.gray)
            }
            .font(.custom("Inter-Black", size: AdaptiveFontSize.adaptive32))
            
            
        }
        .frame(width: 260, height: 260)
    }
}

#Preview {
    CalorieProgressView(currentCalories: 1578, goalCalories: 2000)
}
