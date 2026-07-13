//
//  LiquidBackground.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 09.03.2026.
//

import SwiftUI

struct LiquidBackground: View {
    
    var body: some View {
        ZStack {
            Color(hex: "#252525")
                .ignoresSafeArea()
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.green.opacity(0.45),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 300
                    )
                )
                .frame(width: 250)
                .blur(radius: 90)
                .offset(x: -180, y: -200)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.green.opacity(0.35),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 350
                    )
                )
                .frame(width: 300)
                .blur(radius: 80)
                .offset(x: 200, y: 350)
        }
    }
}

#Preview {
    LiquidBackground()
}
