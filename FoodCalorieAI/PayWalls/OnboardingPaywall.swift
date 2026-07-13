//
//  OnboardingPaywall.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 13.03.2026.
//

import SwiftUI

struct OnboardingPaywall: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var inAppPurchaseViewModel: InAppPurchaseViewModel
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LiquidBackground()
            
            dismissButton
            
            VStack {
                Spacer()
                titleAndSubtitle
                pageControl
                freeTrialInfo
                subscriptions
                Spacer()
                subscribeButton
                footerButtons
            }
            .multilineTextAlignment(.center)
        }
    }
    
    
    private var dismissButton: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    UserDefaults.standard.set(true, forKey: "didSeeOnboarding")
                    dismiss()
                    withAnimation {
                        onboardingViewModel.showOnboarding = false
                        onboardingViewModel.showPaywall = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                }
            }
            Spacer()
        }
        .padding(.trailing)
    }
    
    
    private var pageControl: some View {
        VStack {
            HStack {
                ForEach(0..<4, id: \.self) { index in
                    Capsule()
                        .fill(index == 3 ? Color(hex: "#26B52F") : Color(hex: "#FFFFFF1A").opacity(0.1))
                        .frame(width: 18, height: 6)
                        .animation(.easeInOut, value: 3)
                }
            }
        }
        .padding(.vertical)
    }
    
    
    private var titleAndSubtitle: some View {
        VStack(spacing: 20) {
            Image("imagefasdfasdfasd")
            
            
            Text("Unlock full AI \nnutrition tracking")
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive32))
                .padding(.bottom, 10)
            
            Text("Unlimited scans and \naccess to your diary and profile")
                .font(.custom("Inter-Regular", size: AdaptiveFontSize.adaptive16))
                .foregroundStyle(Color(hex: "#979797"))
                .padding(.horizontal)
                .padding(.bottom)
        }
        .padding(.top)
    }
    
    
    private var freeTrialInfo: some View {
        VStack(spacing: 6) {
            Text("3-day free trial")
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive17))
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .padding()
        .background(
            LiquidGlassBackground(radius: 15)
        )
        .padding(.horizontal)
    }
    
    
    private var subscriptions: some View {
        VStack {
            HStack {
                Text("Weekly trial")
                Spacer()
                Text("\(inAppPurchaseViewModel.getPrice(productID: AppDefaults.freeTrailWeekly, products: inAppPurchaseViewModel.products))/week")
            }
            .font(.custom("Inter-Bold", size: AdaptiveFontSize.adaptive16))
            .foregroundStyle(.white)
            .padding()
            .padding(.vertical, 7)
            .background(
                LiquidGlassBackground(radius: 15)
            )
            
            .padding()
            .padding(.bottom)
        }
    }
    
    
    private var subscribeButton: some View {
        VStack {
            Button {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                UserDefaults.standard.set(true, forKey: "didSeeOnboarding")
                inAppPurchaseViewModel.isLoading = true
                inAppPurchaseViewModel.selectedProductId = AppDefaults.freeTrailWeekly
                Task {
                    if let product = inAppPurchaseViewModel.products.first(where: {$0.id == inAppPurchaseViewModel.selectedProductId }) {
                        await inAppPurchaseViewModel.purchase(product) { result in
                            switch result {
                            case .success(_):
                                inAppPurchaseViewModel.isLoading = false
                                onboardingViewModel.showPaywall = false
                            case .failure(_):
                                inAppPurchaseViewModel.isLoading = false
                                inAppPurchaseViewModel.presentErrorAlert = true
                            }
                        }
                    }
                }
            } label: {
                Text("Subscribe Now")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive16))
                    .background(Color(hex: "#26B52F"))
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
            .padding(.horizontal)
        }
    }
    
    private var footerButtons: some View {
        HStack {
            Button {
                settingsViewModel.openURL(AppDefaults.termsOfUseURL)
            } label: {
                Text("Terms of Use")
            }.padding(.horizontal, 10)
            
            Button {
                settingsViewModel.openURL(AppDefaults.privacyPolicyURL)
            } label: {
                Text("Privacy Policy")
            }
            .padding(.horizontal, 10)
            
            Button {
                Task {
                    await inAppPurchaseViewModel.restorePurchases()
                }
            } label: {
                Text("Restore")
            }
            .padding(.horizontal, 10)
        }
        .foregroundStyle(Color(hex: "#A3A3A3") ?? .gray)
        .font(.custom("Montserrat-Regular", size: AdaptiveFontSize.adaptive11))
        .padding(.top, 1)
    }
}

#Preview {
    OnboardingPaywall()
        .environmentObject(SettingsViewModel())
        .environmentObject(InAppPurchaseViewModel())
        .environmentObject(OnboardingViewModel())
}
