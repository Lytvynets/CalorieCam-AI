//
//  CameraView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 08.03.2026.
//

import SwiftUI

struct CameraView: View {
    
    @EnvironmentObject private var inAppPurchaseViewModel: InAppPurchaseViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var camera: CameraManager
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var openAI: OpenAIService
    @State private var isShowingImagePicker = false
    @State private var showPaywall = false
    
    var body: some View {
        if camera.isLoading {
            loadingScreen
            
        }else{
            ZStack {
                cameraView
                cameraButtons
            }
            .onAppear {
                camera.start()
            }
            .onDisappear {
                camera.stop()
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $camera.image)
            }
            .fullScreenCover(isPresented: $showPaywall, content: {
                OnboardingPaywall()
            })
        }
    }
    
    
    private var loadingScreen: some View {
        ZStack {
            LiquidBackground()
            
            VStack {
                ProgressView()
                    .scaleEffect(2)
                    .tint(.white)
                    .padding()
                
                HStack {
                    Image("mingcute_ai-line")
                    Text("AI analyzes your photo")
                        .font(.system(size: AdaptiveFontSize.adaptive16, weight: .regular, design: .rounded))
                        .foregroundStyle(Color(hex: "#979797"))
                }
            }
        }
    }
    
    
    private var cameraView: some View {
        ZStack {
            CameraPreview(session: camera.session)
                .ignoresSafeArea()
            
            Image("jkghasdlfsadf")
                .padding(.bottom, 150)
        }
    }
    
    
    private var cameraButtons: some View {
        VStack {
            Spacer()
            HStack {
                if #available(iOS 26.0, *) {
                    Button {
                        camera.toggleFlash()
                    } label: {
                        Image(systemName: camera.flashOn ? "bolt.fill" : "bolt.slash")
                            .padding()
                            .clipShape(.circle)
                    }
                    .buttonStyle(.glass)
                } else {
                    Button {
                        camera.toggleFlash()
                    } label: {
                        Image(systemName: camera.flashOn ? "bolt.fill" : "bolt.slash")
                            .padding()
                            .clipShape(.circle)
                    }
                }
                
                Spacer()
                
                Button {
                    if !inAppPurchaseViewModel.isSubscribed {
                        guard profileViewModel.canTakePhoto() else {
                            showPaywall = true
                            return
                        }
                        profileViewModel.savePhotoDate()
                        camera.isLoading = true
                        camera.takePhoto { image in
                            camera.image = image
                            router.push(.scanResultView)
                        }
                    }else{
                        camera.isLoading = true
                        camera.takePhoto { image in
                            camera.image = image
                            router.push(.scanResultView)
                        }
                    }
                } label: {
                    Image("photo-ic")
                }
                
                Spacer()
                
                if #available(iOS 26.0, *) {
                    Button {
                        isShowingImagePicker = true
                    } label: {
                        Image("hhgfdsdgas")
                            .padding()
                            .clipShape(.circle)
                    }
                    .buttonStyle(.glass)
                } else {
                    Button {
                        isShowingImagePicker = true
                    } label: {
                        Image("hhgfdsdgas")
                            .padding()
                            .clipShape(.circle)
                        
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    CameraView()
        .environmentObject(CameraManager())
        .environmentObject(Router())
        .environmentObject(OpenAIService())
}
