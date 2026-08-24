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
    @State private var showExactValue = false
    @State private var exactValue = 50.0
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            header
            ScrollView {
                VStack {
                    foodImage
                    foodInfo
                    if isLoading {
                        loadingIndicator
                    }else{
                        foodContents
                    }
                    sizeButtons
                }
                .background(
                    LiquidGlassBackground()
                )
                .padding()
                
                additionalActions
            }
            .scrollIndicators(.hidden)
        }
        .alert("Food saved to diary", isPresented: $diaryViewModel.showSaveAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert(openAI.errorText, isPresented: $openAI.showErrorAlert) {
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
            isLoading = true
            openAI.analyzeFoodImage(image, portionSize: .small, setExactValue: false, exactValue: 50) { response in
                DispatchQueue.main.async {
                    isLoading = false
                    openAI.resultText = response ?? ""
                }
            }
        }
        .onDisappear {
            openAI.foodName = "Loading..."
            openAI.foodCalories = 0.0
            openAI.foodProtein = 0.0
            openAI.foodFat = 0.0
            openAI.foodCarbs = 0.0
            openAI.foodWeight = 0.0
            openAI.resultText = ""
            openAI.recommendationText = ""
            openAI.portionSize = .small
            openAI.showErrorAlert = false
            openAI.errorText = "Error"
        }
    }
    
    private var header: some View {
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
                        }
                        .opacity(inAppPurchaseViewModel.isSubscribed ? 0 : 1)
                        .disabled(inAppPurchaseViewModel.isSubscribed)
                    }
                }
            }
    }
    
    
    private var loadingIndicator: some View {
        HStack {
            ProgressView()
                .scaleEffect(2)
                .tint(.white)
                .padding()
        }
        .frame(height: 60)
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
            Text(openAI.foodName)
                .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive17))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
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
        .frame(height: 60)
    }
    
    
    private var sizeButtons: some View {
        VStack {
            HStack {
                Text(showExactValue ? "Portion Size: \(Int(exactValue)) " : "Portion Size:")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive14))
                Spacer()
            }
            
            if showExactValue {
                HStack(spacing: 20) {
                    Slider(
                        value: $exactValue,
                        in: 50...1000,
                        step: 1
                    ) { editing in
                        if !editing {
                            guard let image = camera.image  else { return }
                            isLoading = true
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            openAI.analyzeFoodImage(image, portionSize: .small, setExactValue: true, exactValue: exactValue) { response in
                                DispatchQueue.main.async {
                                    openAI.resultText = response ?? ""
                                    isLoading = false
                                }
                            }
                        }
                    }
                    
                    
                    Button {
                        withAnimation {
                            showExactValue = false
                        }
                    } label: {
                        Text("Approximate weight")
                            .font(.custom(!showExactValue ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive12))
                            .padding()
                            .background(!showExactValue ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                            .clipShape(.capsule)
                    }
                }
                .frame(height: 50)
            }else{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        Button {
                            guard let image = camera.image  else { return }
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            openAI.portionSize = .small
                            isLoading = true
                            openAI.analyzeFoodImage(image, portionSize: .small, setExactValue: false, exactValue: 50) { response in
                                DispatchQueue.main.async {
                                    isLoading = false
                                    openAI.resultText = response ?? ""
                                }
                            }
                        } label: {
                            Text("Small")
                                .font(.custom(openAI.portionSize == .small ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive14))
                                .padding()
                                .frame(width: 110)
                                .background(openAI.portionSize == .small ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                                .clipShape(.capsule)
                        }
                        
                        Button {
                            guard let image = camera.image  else { return }
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            openAI.portionSize = .medium
                            isLoading = true
                            openAI.analyzeFoodImage(image, portionSize: .medium, setExactValue: false, exactValue: 50) { response in
                                DispatchQueue.main.async {
                                    openAI.resultText = response ?? ""
                                    isLoading = false
                                }
                            }
                        } label: {
                            Text("Medium")
                                .font(.custom(openAI.portionSize == .medium ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive14))
                                .padding()
                                .frame(width: 110)
                                .background(openAI.portionSize == .medium ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                                .clipShape(.capsule)
                        }
                        
                        Button {
                            guard let image = camera.image  else { return }
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            openAI.portionSize = .large
                            isLoading = true
                            openAI.analyzeFoodImage(image, portionSize: .large, setExactValue: false, exactValue: 50) { response in
                                DispatchQueue.main.async {
                                    openAI.resultText = response ?? ""
                                    isLoading = false
                                }
                            }
                        } label: {
                            Text("Large")
                                .font(.custom(openAI.portionSize == .large ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive14))
                                .padding()
                                .frame(width: 110)
                                .background(openAI.portionSize == .large ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                                .clipShape(.capsule)
                        }
                        
                        
                        Button {
                            withAnimation {
                                showExactValue = true
                            }
                        } label: {
                            Text("Set weight")
                                .font(.custom(showExactValue ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive14))
                                .padding()
                                .frame(width: 110)
                                .background(showExactValue ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                                .clipShape(.capsule)
                        }
                    }
                }
                .frame(height: 50)
            }
        }
        .foregroundStyle(.white)
        .padding()
    }
    
    
    private var additionalActions: some View {
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
                .background(openAI.foodCalories == 0.0 ? .gray : Color(hex: "#0088FF"))
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .disabled(openAI.foodCalories == 0.0)
                .opacity(openAI.foodCalories == 0.0 ? 0.7 : 1)
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
                .background(openAI.foodCalories == 0.0 ? .gray : Color(hex: "#26B52F"))
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .disabled(openAI.foodCalories == 0.0)
                .opacity(openAI.foodCalories == 0.0 ? 0.7 : 1)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 7)
    }
}


#Preview {
    ScanResultView()
        .environmentObject(DiaryViewModel())
        .environmentObject(CameraManager())
        .environmentObject(OpenAIService())
        .environmentObject(InAppPurchaseViewModel())
        .environmentObject(Router())
}
