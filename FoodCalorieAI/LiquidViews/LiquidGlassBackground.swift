//
//  LiquidGlassBackground.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 09.03.2026.
//

import SwiftUI

struct LiquidGlassBackground: View {
    
    @State var radius: CGFloat?
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black.opacity(0.5),
                    Color.black.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .blur(radius: 15)
        }
        .overlay(
            RoundedRectangle(cornerRadius: (radius != nil ? radius : 30) ?? 30)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.8),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: (radius != nil ? radius : 30) ?? 30))
    }
}


#Preview {
    LiquidGlassBackground()
}
