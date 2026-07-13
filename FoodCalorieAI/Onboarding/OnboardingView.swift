//
//  OnboardingView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 14.03.2026.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            LiquidBackground()

            if onboardingViewModel.showPaywall {
                OnboardingPaywall()
            } else {
                VStack {
                    
                     Spacer(minLength: 20)

                    Image(onboardingViewModel.onbItems[onboardingViewModel.currentIndex].imgName)
                        .resizable()
                        .scaledToFit()

                    pageControl
                    titleAndSubtitle

                    Spacer()

                    nextButton
                }
                .frame(maxWidth: 500)
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    
    private var titleAndSubtitle: some View {
        VStack {
            Text(onboardingViewModel.onbItems[onboardingViewModel.currentIndex].title)
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive32))
                .padding(.bottom, 10)
            
            Text(onboardingViewModel.onbItems[onboardingViewModel.currentIndex].subTitle)
                .font(.custom("Inter-Regular", size: AdaptiveFontSize.adaptive16))
                .foregroundStyle(Color(hex: "#979797"))
                .padding(.horizontal)
                .padding(.bottom)
        }
        .multilineTextAlignment(.center)
    }
    
    
    private var pageControl: some View {
        VStack {
            HStack {
                ForEach(0..<4, id: \.self) { index in
                    Capsule()
                        .fill(index == onboardingViewModel.currentIndex ? Color(hex: "#26B52F") : Color(hex: "#FFFFFF1A").opacity(0.1))
                        .frame(width: 18, height: 6)
                        .animation(.easeInOut, value: onboardingViewModel.currentIndex)
                }
            }
        }
        .padding(.vertical)
    }
    
    
    private var nextButton: some View {
        VStack {
            Button {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                withAnimation {
                    if onboardingViewModel.currentIndex + 1 < onboardingViewModel.onbItems.count {
                        onboardingViewModel.currentIndex += 1
                    } else {
                        onboardingViewModel.showPaywall = true
                    }
                }
            } label: {
                Text("Next")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive16))
                    .background(Color(hex: "#26B52F"))
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
            .padding()
        }
    }
}


#Preview {
    OnboardingView()
        .environmentObject(OnboardingViewModel())
}
