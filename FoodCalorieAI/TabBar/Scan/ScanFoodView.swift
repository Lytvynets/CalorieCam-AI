//
//  ContentView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 31.07.2025.
//

import SwiftUI
import AVFoundation

struct ScanFoodView: View {
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject  var router: Router
    @EnvironmentObject var inAppPurchaseViewModel: InAppPurchaseViewModel
    @State private var showPermissionAlert = false

    
    var body: some View {
        ZStack {
            LiquidBackground()
            header
            if !profileViewModel.canTakePhoto() {
                if !inAppPurchaseViewModel.isSubscribed {
                    cameraButtonWithoutPremium
                }else{
                    cameraButton
                }
            }else{
                cameraButton
            }
        }
        .alert("Camera Access Needed", isPresented: $showPermissionAlert) {
            
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            
            Button("Cancel", role: .cancel) { }
            
        } message: {
            Text("Please allow camera access in Settings to take photos.")
        }
    }
    
    
    private var header: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    if !inAppPurchaseViewModel.isSubscribed {
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Image("akar-icons_crown")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                .clipShape(Circle())
                .padding(.trailing)
                .opacity(inAppPurchaseViewModel.isSubscribed ? 0 : 1)
                .disabled(inAppPurchaseViewModel.isSubscribed)
                .modifier(GlassButtonModifier())
            }
            .overlay {
                Text("CalorieCam AI")
                    .font(.system(size: AdaptiveFontSize.adaptive20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.top, 3)
            }
            
            Spacer()
        }
    }
    
    
    private var cameraButton: some View {
        VStack {
            Button {           
                handleCameraTap()
            } label: {
                Image("gdfgdfd")
            }
            
            Text("Take a photo of your meal to analyze")
                .font(.custom("Inter-Regular", size: AdaptiveFontSize.adaptive16))
                .foregroundStyle(Color(hex: "#979797"))
                .padding()
        }
    }
    
    func handleCameraTap() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            router.push(.camera)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        router.push(.camera)
                    }
                }
            }
            
        case .denied, .restricted:
            showPermissionAlert = true
            
        @unknown default:
            break
        }
    }
    
    private var cameraButtonWithoutPremium: some View {
        VStack {
            Button {
                inAppPurchaseViewModel.showInAppPaywall = true
            } label: {
                Image("safsadfa")
            }
            
            Text("You’ve reached your photo scanning limit. \nCome back tomorrow, or upgrade to Pro \nfor unlimited access.")
                .font(.custom("Inter-Regular", size: AdaptiveFontSize.adaptive16))
                .foregroundStyle(Color(hex: "#979797"))
                .padding()
                .multilineTextAlignment(.center)
            
            
            Button {
                inAppPurchaseViewModel.showInAppPaywall = true
            } label: {
                HStack {
                    Image("akar-icons_crown")
                        .resizable()
                        .frame(width: 25, height: 25)
                    
                    Text("Upgrade to Pro")
                    
                }
                .font(.system(size: AdaptiveFontSize.adaptive16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#26B52F"))
                .clipShape(.capsule)
                .padding(.horizontal, 25)
            }
        }
    }
}


#Preview {
    ScanFoodView()
        .environmentObject(Router())
        .environmentObject(InAppPurchaseViewModel())
}



struct GlassButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.buttonStyle(.glass)
        } else {
            content
        }
    }
}
