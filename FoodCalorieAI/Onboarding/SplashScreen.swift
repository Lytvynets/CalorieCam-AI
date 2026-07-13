//
//  SplashScreen.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 15.03.2026.
//

import SwiftUI

struct SplashScreen: View {
    
    @State private var scanOffset: CGFloat = -138
    @State private var showScanner = true
    @State private var showText = false
    
    var body: some View {
        ZStack {
            LiquidBackground()
            
            VStack(spacing: 20) {
                
                ZStack {
                    Image("imagegerfewfe")
                        .resizable()
                        .frame(width: 277, height: 277)
                    
                    if showScanner {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .clear,
                                        .green.opacity(0.8),
                                        .green,
                                        .green.opacity(0.8),
                                        .clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 277, height: 4)
                            .blur(radius: 1)
                            .shadow(color: .green, radius: 8)
                            .offset(y: scanOffset)
                    }
                }
                .frame(width: 277, height: 277)
                .clipped()
                .onAppear {
                    
                    withAnimation(.linear(duration: 1.2)) {
                        scanOffset = 138
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation(.linear(duration: 1.2)) {
                            scanOffset = -138
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            showScanner = false
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                        withAnimation(.easeIn(duration: 0.6)) {
                            showText = true
                        }
                    }
                }
                
                if showText {
                    Text("CalorieCam AI")
                        .foregroundStyle(.white)
                        .font(.custom("Inter-Bold", size: AdaptiveFontSize.adaptive33))
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }else{
                    Text(" ")
                        .foregroundStyle(.white)
                        .font(.custom("Inter-Bold", size: AdaptiveFontSize.adaptive33))
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
    }
}


#Preview {
    SplashScreen()
}
