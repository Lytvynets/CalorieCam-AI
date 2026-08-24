//
//  UserProfileView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 01.08.2025.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var inAppPurchaseViewModel: InAppPurchaseViewModel
    
    var body: some View {
        ZStack {
            LiquidBackground()
            header
            ScrollView {
                VStack(spacing: 15) {
                    genderSelect
                    userData
                    activity
                    goalView
                    calculateButton
                }
                .padding(.bottom)
            }
            .padding(.top, 55)
        }
    }
    
    
    private var header: some View {
        VStack {
            HStack {
                Spacer()
                Image("noto-v1_fire")
                Text("\(String(describing: profileViewModel.dailyCalories ?? 0))")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive19))
                    .foregroundStyle(.white)
            }.overlay {
                Text("Profile")
                    .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive20))
                    .foregroundStyle(.white)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    
    private var genderSelect: some View {
        VStack {
            HStack {
                Text("Gender:")
                    .font(.system(size: AdaptiveFontSize.adaptive17, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
            
            HStack {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    if inAppPurchaseViewModel.isSubscribed {
                        profileViewModel.gender = .male
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    HStack {
                        Image("material-symbols_male")
                        Text("Male")
                    }
                    .font(.custom(profileViewModel.gender == .male ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive15))
                    .padding(10)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(profileViewModel.gender == .male ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                    .clipShape(.capsule)
                }
                
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    if inAppPurchaseViewModel.isSubscribed {
                        profileViewModel.gender = .female
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    HStack {
                        Image("material-symbols_female")
                        Text("Female")
                    }
                    .font(.custom(profileViewModel.gender == .female ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive15))
                    .padding(10)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(profileViewModel.gender == .female ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                    .clipShape(.capsule)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(
            LiquidGlassBackground()
        )
        .padding(.horizontal)
    }
    
    
    private var userData: some View {
        VStack {
            HStack {
                Text("Age:")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive14))
                    .foregroundStyle(.white)
                    .padding(.leading, 20)
                
                Spacer()
                
                customStepperAge(age: "\(profileViewModel.age)")
                
                Text("years")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive14))
                    .foregroundStyle(.white)
                    .padding(.trailing)
            }
            .padding(.top)
            
            HStack {
                Text("Height:")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive14))
                    .foregroundStyle(.white)
                    .padding(.leading, 20)
                Spacer()
                
                customStepperHeight(height: "\(profileViewModel.height)")
                
                Text("cm")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive14))
                    .foregroundStyle(.white)
                    .padding(.trailing, 35)
            }
            
            HStack {
                Text("Weight:")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive14))
                    .foregroundStyle(.white)
                    .padding(.leading, 20)
                
                Spacer()
                
                customStepperWeight(weight: "\(profileViewModel.weight)")
                
                Text("kg")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive14))
                    .foregroundStyle(.white)
                    .padding(.trailing, 35)
            }
            .padding(.bottom)
        }
        .background(
            LiquidGlassBackground()
        )
        .padding(.horizontal)
    }
    
    
    private func customStepperAge(age: String) -> some View {
        HStack {
            Text("\(age)")
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive14))
                .foregroundStyle(.white)
                .frame(width: 70)
                .multilineTextAlignment(.leading)
            
            VStack {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    if inAppPurchaseViewModel.isSubscribed {
                        if profileViewModel.age < 100 {
                            profileViewModel.age += 1
                        }
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Image("ferfwergew")
                        .padding(.top, 6)
                        .padding(.horizontal)
                }
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    if inAppPurchaseViewModel.isSubscribed {
                        if profileViewModel.age > 0 {
                            profileViewModel.age -= 1
                        }
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Image("gergewfwef")
                        .padding(.bottom, 6)
                        .padding(.horizontal)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 100)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.gray)
        )
    }
    
    
    private func customStepperHeight(height: String) -> some View {
        HStack {
            Text("\(height)")
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive14))
                .foregroundStyle(.white)
                .frame(width: 70)
                .multilineTextAlignment(.leading)
            
            VStack {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    if inAppPurchaseViewModel.isSubscribed {
                        if profileViewModel.height < 300 {
                            profileViewModel.height += 1
                        }
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Image("ferfwergew")
                        .padding(.top, 6)
                        .padding(.horizontal)
                }
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    if inAppPurchaseViewModel.isSubscribed {
                        if profileViewModel.height > 0 {
                            profileViewModel.height -= 1
                        }
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Image("gergewfwef")
                        .padding(.bottom, 6)
                        .padding(.horizontal)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 100)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.gray)
        )
    }
    
    
    private func customStepperWeight(weight: String) -> some View {
        HStack {
            Text("\(weight)")
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive14))
                .foregroundStyle(.white)
                .frame(width: 70)
                .multilineTextAlignment(.leading)
            
            VStack {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if inAppPurchaseViewModel.isSubscribed {
                        if profileViewModel.weight < 300 {
                            profileViewModel.weight += 1
                        }
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                    
                } label: {
                    Image("ferfwergew")
                        .padding(.top, 6)
                        .padding(.horizontal)
                }
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if inAppPurchaseViewModel.isSubscribed {
                        if profileViewModel.weight > 0 {
                            profileViewModel.weight -= 1
                        }
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                    
                } label: {
                    Image("gergewfwef")
                        .padding(.bottom, 6)
                        .padding(.horizontal)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 100)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.gray)
        )
    }
    
    
    private var activity: some View {
        VStack {
            HStack {
                Text("Activity Level:")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive14))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
            
            HStack {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if inAppPurchaseViewModel.isSubscribed {
                        profileViewModel.activityLevel = 1.2
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Text("Sedentary")
                        .font(.custom(profileViewModel.activityLevel == 1.2 ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive13))
                        .padding(10)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(profileViewModel.activityLevel == 1.2 ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                        .clipShape(.capsule)
                }
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if inAppPurchaseViewModel.isSubscribed {
                        profileViewModel.activityLevel = 1.4
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Text("Moderate")
                        .font(.custom(profileViewModel.activityLevel == 1.4 ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive13))
                        .padding(10)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(profileViewModel.activityLevel == 1.4 ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                        .clipShape(.capsule)
                }
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if inAppPurchaseViewModel.isSubscribed {
                        profileViewModel.activityLevel = 1.6
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Text("Active")
                        .font(.custom(profileViewModel.activityLevel == 1.6 ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive13))
                        .padding(10)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(profileViewModel.activityLevel == 1.6 ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                        .clipShape(.capsule)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(
            LiquidGlassBackground()
        )
        .padding(.horizontal)
    }
    
    
    private var goalView: some View {
        VStack {
            HStack {
                Text("Goal:")
                    .font(.custom("Inter-ExtraBold", size: AdaptiveFontSize.adaptive14))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
            
            HStack {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if inAppPurchaseViewModel.isSubscribed {
                        profileViewModel.goal = .loseWeight
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Text("Lose weight")
                        .font(.custom(profileViewModel.goal == .loseWeight ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive13))
                        .padding(10)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(profileViewModel.goal == .loseWeight ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                        .clipShape(.capsule)
                }
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if inAppPurchaseViewModel.isSubscribed {
                        profileViewModel.goal = .maintainWeight
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Text("Maintain")
                        .font(.custom(profileViewModel.goal == .maintainWeight ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive13))
                        .padding(10)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(profileViewModel.goal == .maintainWeight ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                        .clipShape(.capsule)
                }
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if inAppPurchaseViewModel.isSubscribed {
                        profileViewModel.goal = .gainWeight
                    }else{
                        inAppPurchaseViewModel.showInAppPaywall = true
                    }
                } label: {
                    Text("Gain weight")
                        .font(.custom(profileViewModel.goal == .gainWeight ? "Inter-ExtraBold" : "Inter-Medium", size: AdaptiveFontSize.adaptive13))
                        .padding(10)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(profileViewModel.goal == .gainWeight ? Color(hex: "#26B52F") : Color.black.opacity(0.5))
                        .clipShape(.capsule)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(
            LiquidGlassBackground()
        )
        .padding(.horizontal)
    }
    
    
    private var calculateButton: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            if inAppPurchaseViewModel.isSubscribed {
                profileViewModel.dailyCalories = CalorieCalculator.calculateCalorieNeeds(weightKg: profileViewModel.weight, heightCm: profileViewModel.height, age: profileViewModel.age, gender: profileViewModel.gender, activityLevel: profileViewModel.activityLevel, goal: profileViewModel.goal)
            }else{
                inAppPurchaseViewModel.showInAppPaywall = true
            }
        } label: {
            HStack {
                Image("solar_calculator-linear")
                Text("Calculate calorie goal")
            }
            .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive16))
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#26B52F"))
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding(.horizontal)
        }
    }
}


#Preview {
    ProfileView()
        .environmentObject(ProfileViewModel())
        .environmentObject(InAppPurchaseViewModel())
}
