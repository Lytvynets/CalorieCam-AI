//
//  InAppPaywallView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 13.03.2026.
//

import SwiftUI

enum SubsPlan {
    case weekly
    case monthly
    case annually
}

struct InAppPaywallView: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var inAppPurchaseViewModel: InAppPurchaseViewModel
    @Environment(\.dismiss) var dismiss
    @State var freeTrial = true
    @State private var subsPlan: SubsPlan = .weekly
    
    var body: some View {
        ZStack {
            LiquidBackground()
            
            ScrollView {
                VStack {
                    titleAndSubtitle
                    freeTrialSwitcher
                    subscriptions
                    subscribeButton
                    footerButtons
                }
                .multilineTextAlignment(.center)
            }
            .scrollIndicators(.hidden)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .padding()
                    }
                    .contentShape(Rectangle())
                }
                Spacer()
            }
        }
        .overlay {
            if inAppPurchaseViewModel.isLoading {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                        .opacity(0.5)
                    
                    ProgressView()
                }
            }
        }
    }
    
    
    private var dismissButton: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                }
            }
            Spacer()
        }
        .padding(.trailing)
    }
    
    
    private var titleAndSubtitle: some View {
        VStack {
            Image("Frame000004015")
            
            Text("Unlock full AI \nnutrition tracking")
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive32))
                .padding(.bottom, 10)
            
            Text("Unlimited scans and \naccess to your diary and profile")
                .font(.custom("Inter-Regular", size: AdaptiveFontSize.adaptive16))
                .foregroundStyle(Color(hex: "#979797"))
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
    
    
    private var freeTrialSwitcher: some View {
        VStack {
            HStack {
                Text("Start with a 3-day free trial")
                    .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive14))
//                Spacer()
//                Toggle("", isOn: $freeTrial)
//                    .onChange(of: freeTrial) { newValue in
//                        if newValue {
//                            if inAppPurchaseViewModel.selectedProductId == AppDefaults.weekly {
//                                inAppPurchaseViewModel.selectedProductId = AppDefaults.freeTrailWeekly
//                            }
//                            
//                            if inAppPurchaseViewModel.selectedProductId == AppDefaults.monthly {
//                                inAppPurchaseViewModel.selectedProductId = AppDefaults.freeTrailMonthly
//                            }
//                            
//                            if inAppPurchaseViewModel.selectedProductId == AppDefaults.yearly {
//                                inAppPurchaseViewModel.selectedProductId = AppDefaults.freeTrailYearly
//                            }
//                        }else{
//                            if inAppPurchaseViewModel.selectedProductId == AppDefaults.freeTrailWeekly {
//                                inAppPurchaseViewModel.selectedProductId = AppDefaults.weekly
//                            }
//                            
//                            if inAppPurchaseViewModel.selectedProductId == AppDefaults.freeTrailMonthly {
//                                inAppPurchaseViewModel.selectedProductId = AppDefaults.monthly
//                            }
//                            
//                            if inAppPurchaseViewModel.selectedProductId == AppDefaults.freeTrailYearly {
//                                inAppPurchaseViewModel.selectedProductId = AppDefaults.yearly
//                            }
//                        }
//                    }
                
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .padding()
            .background(
                LiquidGlassBackground(radius: 15)
            )
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    
    private var subscriptions: some View {
        VStack {
            HStack {
                Image(subsPlan == .weekly ? "radio" : "radio_1")
                Text("Weekly")
                    .font(.custom("Inter-Bold", size: AdaptiveFontSize.adaptive16))
                Spacer()
                Text(freeTrial ? inAppPurchaseViewModel.getPrice(productID: AppDefaults.freeTrailWeekly, products: inAppPurchaseViewModel.products) : inAppPurchaseViewModel.getPrice(productID: AppDefaults.weekly, products: inAppPurchaseViewModel.products))
                    .font(.custom("Inter-Bold", size: AdaptiveFontSize.adaptive18))
            }
            .foregroundStyle(.white)
            .padding()
            .padding(.vertical, 7)
            .background(
                LiquidGlassBackground(radius: 15)
            )
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth:  subsPlan == .weekly ? 2 : 0)
                    .foregroundStyle(Color(hex: "#26B52F"))
            )
            .padding(.horizontal)
            .onTapGesture {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                subsPlan = .weekly
                if freeTrial {
                    inAppPurchaseViewModel.selectedProductId = AppDefaults.freeTrailWeekly
                }else{
                    inAppPurchaseViewModel.selectedProductId = AppDefaults.weekly
                }
            }
            
            HStack {
                Image(subsPlan == .monthly ? "radio" : "radio_1")
                Text("Monthly")
                    .font(.custom("Inter-Bold", size: AdaptiveFontSize.adaptive16))
                Spacer()
                Text(freeTrial ? inAppPurchaseViewModel.getPrice(productID: AppDefaults.freeTrailMonthly, products: inAppPurchaseViewModel.products) : inAppPurchaseViewModel.getPrice(productID: AppDefaults.monthly, products: inAppPurchaseViewModel.products))
                    .font(.custom("Inter-Bold", size: AdaptiveFontSize.adaptive18))
                
            }
            .foregroundStyle(.white)
            .padding(.vertical, 7)
            .padding()
            .background(
                LiquidGlassBackground(radius: 15)
            )
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth:  subsPlan == .monthly ? 2 : 0)
                    .foregroundStyle(Color(hex: "#26B52F"))
            )
            .padding(.horizontal)
            .padding(.vertical, 10)
            .onTapGesture {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                subsPlan = .monthly
                if freeTrial {
                    inAppPurchaseViewModel.selectedProductId = AppDefaults.freeTrailMonthly
                }else{
                    inAppPurchaseViewModel.selectedProductId = AppDefaults.monthly
                }
            }
            
            HStack {
                Image(subsPlan == .annually ? "radio" : "radio_1")
                Text("Yearly")
                    .font(.custom("Inter-Bold", size: AdaptiveFontSize.adaptive16))
                Spacer()
                Text(freeTrial ? inAppPurchaseViewModel.getPrice(productID: AppDefaults.freeTrailYearly, products: inAppPurchaseViewModel.products) : inAppPurchaseViewModel.getPrice(productID: AppDefaults.yearly, products: inAppPurchaseViewModel.products))
                    .font(.custom("Inter-Bold", size: AdaptiveFontSize.adaptive18))
            }
            .foregroundStyle(.white)
            .padding(.vertical, 7)
            .padding()
            .background(
                LiquidGlassBackground(radius: 15)
            )
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth:  subsPlan == .annually ? 2 : 0)
                    .foregroundStyle(Color(hex: "#26B52F"))
            )
            .padding(.horizontal)
            .onTapGesture {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                subsPlan = .annually
                if freeTrial {
                    inAppPurchaseViewModel.selectedProductId = AppDefaults.freeTrailYearly
                }else{
                    inAppPurchaseViewModel.selectedProductId = AppDefaults.yearly
                }
            }
        }
    }
    
    
    private var subscribeButton: some View {
        VStack {
            Button {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                inAppPurchaseViewModel.isLoading = true
                Task {
                    if let product = inAppPurchaseViewModel.products.first(where: {$0.id == inAppPurchaseViewModel.selectedProductId }) {
                        await inAppPurchaseViewModel.purchase(product) { result in
                            switch result {
                            case .success(_):
                                inAppPurchaseViewModel.isLoading = false
                                dismiss()
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
            .padding()
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
    }
    
    
}

#Preview {
    InAppPaywallView()
        .environmentObject(SettingsViewModel())
        .environmentObject(InAppPurchaseViewModel())
}
