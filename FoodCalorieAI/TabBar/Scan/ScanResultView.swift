//
//  ScanResultView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 08.03.2026.
//

import SwiftUI

struct ScanResultView: View {
    
    
    @EnvironmentObject private var inAppPurchaseViewModel: InAppPurchaseViewModel
    @EnvironmentObject private var diaryViewModel: DiaryViewModel
    @EnvironmentObject private var camera: CameraManager
    @EnvironmentObject private var openAI: OpenAIService
    @EnvironmentObject private var router: Router
    @State private var isLoading = true
    @State private var showPaywall = false
    @State var selected = false
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            LiquidBackground()
                .navigationTitle("Scan Result")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if !inAppPurchaseViewModel.isSubscribed {
                        ToolbarItem(placement: .navigationBarTrailing) {
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
                            .opacity(inAppPurchaseViewModel.isSubscribed ? 0 : 1)
                            .disabled(inAppPurchaseViewModel.isSubscribed)
                            .modifier(GlassButtonModifier())
                        }
                    }
                    
                }
            
            ScrollView {
                VStack {
                    foodImage
                    foodInfo
                    foodContents
                    sizeButtons
                }
                .background(
                    LiquidGlassBackground()
                )
                .padding()
                
                HStack(spacing: 10) {
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        if inAppPurchaseViewModel.isSubscribed {
                            router.push(.recommendationView)
                        }else{
                            showPaywall = true
                        }
                    } label: {
                        HStack {
                            Image("mingcute_ai-line")
                            Text("AI Alternative")
                        }
                        .font(.system(size: AdaptiveFontSize.adaptive16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#0088FF"))
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                    }
                    
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        if inAppPurchaseViewModel.isSubscribed {
                            if let image = camera.image {
                                diaryViewModel.newCalories = "\(openAI.foodCalories)"
                                diaryViewModel.newName = openAI.foodName
                                diaryViewModel.selectedImage = image
                                diaryViewModel.addFood(name: openAI.foodName, userCalories: openAI.foodCalories, image: image)
                            }
                        }else{
                            showPaywall = true
                        }
                    } label: {
                        HStack {
                            Image("material-symbols_add-rounded")
                            Text("Add to Diary")
                        }
                        .font(.system(size: AdaptiveFontSize.adaptive16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#26B52F"))
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                    }
                }
                .padding()
            }
        }
        .alert("Food saved to diary", isPresented: $diaryViewModel.showSaveAlert) {
                 Button("OK", role: .cancel) { }
        }
        .fullScreenCover(isPresented: $showPaywall, content: {
            OnboardingPaywall()
        })
        .onAppear {
            diaryViewModel.setContext(viewContext)
        }
        .onAppear {
            camera.isLoading = false
            guard let image = camera.image  else { return }
            openAI.analyzeFoodImage(image, portionSize: .small) { response in
                DispatchQueue.main.async {
                    openAI.resultText = response ?? ""
                }
            }
        }
    }
    
    
    private var foodImage: some View {
        ZStack {
            if let image = camera.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 318)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(hex: "#565656"), lineWidth: 1)
                    )
                    .clipped()
                    .padding(.horizontal)
            }else{
                Image("Rectangle 2605")
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(height: 318)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .scaledToFit()
            }
        }
        .padding(.top)
    }
    
    
    private var foodInfo: some View {
        HStack {
            Text("\(openAI.foodName)")
                .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive17))
            Spacer()
            
            Image("")
            
            Text("\(Int(openAI.foodCalories))")
                .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive24))
            
            Text("kcal")
                .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive13))
        }
        .foregroundStyle(.white)
        .padding()
    }
    
    
    private var foodContents: some View {
        HStack {
            VStack{
                Text("Protein")
                    .font(.custom("Inter-Medium", size: AdaptiveFontSize.adaptive12))
                
                Text("\(Int(openAI.foodProtein)) g")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive18))
            }
            .frame(width: 76, height: 62)
            .background(Color(hex: "#26B52F"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack{
                Text("Fat")
                    .font(.custom("Inter-Medium", size: AdaptiveFontSize.adaptive12))
                
                Text("\(Int(openAI.foodFat)) g")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive18))
                
            }
            .frame(width: 76, height: 62)
            .background(Color(hex: "#FF8D28"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack{
                Text("Carbs")
                    .font(.custom("Inter-Medium", size: AdaptiveFontSize.adaptive12))
                
                Text("\(Int(openAI.foodCarbs)) g")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive18))
            }
            .frame(width: 76, height: 62)
            .background(Color(hex: "#00C8B3"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack{
                Text("Weight")
                    .font(.custom("Inter-Medium", size: AdaptiveFontSize.adaptive12))
                
                Text("\(Int(openAI.foodWeight)) g")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive18))
            }
            .frame(width: 76, height: 62)
            .background(Color(hex: "#0088FF"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .foregroundStyle(.white)
    }
    
    
    private var sizeButtons: some View {
        VStack {
            HStack {
                Text("Portion Size:")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive14))
                
                Spacer()
            }
            
            HStack(spacing: 20) {
                Button {
                    guard let image = camera.image  else { return }
                    openAI.portionSize = .small
                    openAI.analyzeFoodImage(image, portionSize: .small) { response in
                        DispatchQueue.main.async {
                            openAI.resultText = response ?? ""
                        }
                    }
                } label: {
                    Text("Small")
                        .font(.custom(openAI.portionSize == .small ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive15))
                        .padding()
                        .frame(width: 100)
                        .background(openAI.portionSize == .small ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                        .clipShape(.capsule)
                }
                
                Button {
                    guard let image = camera.image  else { return }
                    openAI.portionSize = .medium
                    openAI.analyzeFoodImage(image, portionSize: .medium) { response in
                        DispatchQueue.main.async {
                            openAI.resultText = response ?? ""
                        }
                    }
                } label: {
                    Text("Medium")
                        .font(.custom(openAI.portionSize == .medium ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive15))
                        .padding()
                        .frame(width: 100)
                        .background(openAI.portionSize == .medium ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                        .clipShape(.capsule)
                }
                
                Button {
                    guard let image = camera.image  else { return }
                    openAI.portionSize = .large
                    openAI.analyzeFoodImage(image, portionSize: .large) { response in
                        DispatchQueue.main.async {
                            openAI.resultText = response ?? ""
                        }
                    }
                } label: {
                    Text("Large")
                        .font(.custom(openAI.portionSize == .large ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive15))
                        .padding()
                        .frame(width: 100)
                        .background(openAI.portionSize == .large ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                        .clipShape(.capsule)
                }
            }
        }
        .foregroundStyle(.white)
        .padding()
    }
}


#Preview {
    ScanResultView()
        .environmentObject(CameraManager())
        .environmentObject(OpenAIService())
        .environmentObject(Router())
}
