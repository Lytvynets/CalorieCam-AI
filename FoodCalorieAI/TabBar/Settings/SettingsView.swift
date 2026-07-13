//
//  SettingsView.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 08.03.2026.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @EnvironmentObject private var inAppPurchaseViewModel: InAppPurchaseViewModel
    @State private var showNotificationAlert = false
    
    var body: some View {
        ZStack {
            LiquidBackground()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
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
                        .padding(.trailing)
                        .opacity(inAppPurchaseViewModel.isSubscribed ? 0 : 1)
                        .disabled(inAppPurchaseViewModel.isSubscribed)
                        .modifier(GlassButtonModifier())
                    }
                }
            
            header
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    VStack {
                        HStack {
                            Image("streamline_web")
                            Text("Response Language")
                            Spacer()
                            Text(settingsViewModel.responseLanguage)
                                .font(.custom("Inter-Medium", size: AdaptiveFontSize.adaptive14))
                            Image("weui_arrow-outlined")
                            
                        }
                        .foregroundStyle(.white)
                        .onTapGesture {
                            router.push(.responseLanguageView)
                        }
                        
                        Divider()
                            .background(.white)
                            .padding(.vertical, 10)
                        
                        HStack {
                            Image("basil_notification-outline")
                            Text("Notifications")
                            Spacer()
                            Toggle("", isOn: $settingsViewModel.notificationsIsOn)
                                .onChange(of: settingsViewModel.notificationsIsOn) { isOn in
                                    if isOn {
                                        handleNotificationToggle()
                                    } else {
                                        NotificationManager.shared.disableNotifications()
                                    }
                                }
                        }
                        .foregroundStyle(.white)
                        
                        if settingsViewModel.notificationsIsOn {
                            
                            Divider()
                                .background(.white)
                                .padding(.vertical, 10)
                            
                            HStack {
                                Image("basil_notification-outline")
                                Text("Notification Time")
                                Spacer()
                                
                            }
                            .foregroundStyle(.white)
                            
                            HStack(spacing: 30) {
                                customStepperHours(time: String(format: "%02d", settingsViewModel.notificationHours))
                                customStepperMinutes(time: String(format: "%02d", settingsViewModel.notificationMinutes))
                                customStepperTime(time: settingsViewModel.notificationTimeAM == true ? "AM" : "PM")
                            }
                            .onChange(of: settingsViewModel.notificationHours) { _, _ in
                                updateNotification()
                            }
                            .onChange(of: settingsViewModel.notificationMinutes) { _, _  in
                                updateNotification()
                            }
                            .onChange(of: settingsViewModel.notificationTimeAM) { _, _ in
                                updateNotification()
                            }
                        }
                    }
                    .padding()
                    .padding(.vertical, 5)
                    .background(
                        LiquidGlassBackground(radius: 15)
                    )
                    .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            Image("material-symbols_privacy-tip-outline")
                            Text("Privacy Policy")
                            Spacer()
                            Image("weui_arrow-outlined")
                        }
                        .foregroundStyle(.white)
                        .onTapGesture {
                            settingsViewModel.openURL(AppDefaults.privacyPolicyURL)
                        }
                        
                        Divider()
                            .background(.white)
                            .padding(.vertical, 8)
                        
                        HStack {
                            Image("majesticons_list-box-line")
                            Text("Terms of Use")
                            Spacer()
                            Image("weui_arrow-outlined")
                        }
                        .foregroundStyle(.white)
                        .onTapGesture {
                            settingsViewModel.openURL(AppDefaults.termsOfUseURL)
                        }
                        
                        Divider()
                            .background(.white)
                            .padding(.vertical, 8)
                        
                        HStack {
                            Image("mingcute_star-line")
                            Text("Leave a Review")
                            Spacer()
                            Image("weui_arrow-outlined")
                        }
                        .foregroundStyle(.white)
                        .onTapGesture {
                            settingsViewModel.requestReview()
                        }
                        
                        Divider()
                            .background(.white)
                            .padding(.vertical, 8)
                        
                        HStack {
                            Image("uil_share")
                            Text("Share the App")
                            Spacer()
                            Image("weui_arrow-outlined")
                        }
                        .foregroundStyle(.white)
                        .onTapGesture {
                            settingsViewModel.showShareSheet = true
                        }
                        
                        Divider()
                            .background(.white)
                            .padding(.vertical, 8)
                        
                        HStack {
                            Image("ix_restore")
                            Text("Restore Purchases")
                            Spacer()
                            Image("weui_arrow-outlined")
                        }
                        .foregroundStyle(.white)
                        .onTapGesture {
                            Task {
                                await inAppPurchaseViewModel.restorePurchases()
                            }
                        }
                    }
                    .padding()
                    .padding(.vertical, 5)
                    .background(
                        LiquidGlassBackground(radius: 15)
                    )
                    .padding(.horizontal)
                }
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive14))
            }
            .padding(.top, 55)
        }
        .onAppear {
            let notificationsIsOn = UserDefaults.standard.object(forKey: "notificationsIsOn") as? Bool ?? false
            settingsViewModel.notificationsIsOn = notificationsIsOn
            
        }
        .sheet(isPresented: $settingsViewModel.showShareSheet, content: {
            if let url = URL(string: AppDefaults.appURL) {
                ShareSheetURL(activityItems: [url])
            }
        })
        .alert("Enable Notifications", isPresented: $showNotificationAlert) {
            
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            
            Button("Cancel", role: .cancel) { }
            
        } message: {
            Text("Notifications are disabled. Please enable them in Settings to receive reminders.")
        }
    }
    
    func handleNotificationToggle() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            DispatchQueue.main.async {
                
                switch settings.authorizationStatus {
                    
                case .authorized:
                    scheduleNotification()
                    
                case .notDetermined:
                    NotificationManager.shared.requestPermission { granted in
                        DispatchQueue.main.async {
                            if granted {
                                scheduleNotification()
                                UserDefaults.standard.set(true, forKey: "notificationsIsOn")
                                
                            } else {
                                UserDefaults.standard.set(false, forKey: "notificationsIsOn")
                                
                                settingsViewModel.notificationsIsOn = false
                            }
                        }
                    }
                    
                case .denied:
                    settingsViewModel.notificationsIsOn = false
                    showNotificationAlert = true
                    
                default:
                    break
                }
            }
        }
    }
    
    
    func scheduleNotification() {
        let period = settingsViewModel.notificationTimeAM ? "AM" : "PM"
        
        NotificationManager.shared.scheduleDailyNotification(
            timeString: "\(settingsViewModel.notificationHours):\(settingsViewModel.notificationMinutes) \(period)"
        )
    }
    
    func updateNotification() {
        let hour = String(format: "%02d", settingsViewModel.notificationHours)
        let minute = String(format: "%02d", settingsViewModel.notificationMinutes)
        let ampm = settingsViewModel.notificationTimeAM ? "AM" : "PM"
        
        let timeString = "\(hour):\(minute) \(ampm)"
        NotificationManager.shared.removeAll()
        if settingsViewModel.notificationsIsOn {
            NotificationManager.shared.scheduleDailyNotification(timeString: timeString)
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
                Text("Settings")
                    .font(.system(size: AdaptiveFontSize.adaptive20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.top, 3)
            }
            
            Spacer()
        }
    }
    
    
    private func customStepperHours(time: String) -> some View {
        HStack {
            Text("\(time)")
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive14))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.leading)
            
            VStack {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if settingsViewModel.notificationHours < 12 {
                        settingsViewModel.notificationHours += 1
                    }
                } label: {
                    Image("ferfwergew")
                        .padding(.top, 6)
                        .padding(.trailing)
                }
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if settingsViewModel.notificationHours > 0 {
                        settingsViewModel.notificationHours -= 1
                    }
                } label: {
                    Image("gergewfwef")
                        .padding(.bottom, 6)
                        .padding(.trailing)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 100)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.gray)
        )
    }
    
    
    private func customStepperMinutes(time: String) -> some View {
        HStack {
            Text("\(time)")
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive14))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.leading)
            
            VStack {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if settingsViewModel.notificationMinutes < 59 {
                        settingsViewModel.notificationMinutes += 1
                    }
                } label: {
                    Image("ferfwergew")
                        .padding(.top, 6)
                        .padding(.trailing)
                }
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    if  settingsViewModel.notificationMinutes > 0 {
                        settingsViewModel.notificationMinutes -= 1
                    }
                } label: {
                    Image("gergewfwef")
                        .padding(.bottom, 6)
                        .padding(.trailing)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 100)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.gray)
        )
    }
    
    
    private func customStepperTime(time: String) -> some View {
        HStack {
            Text("\(time)")
                .font(.custom("Inter-SemiBold", size: AdaptiveFontSize.adaptive12))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.leading)
            
            VStack {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    settingsViewModel.notificationTimeAM = true
                } label: {
                    Image("ferfwergew")
                        .padding(.top, 6)
                        .padding(.trailing)
                }
                
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    settingsViewModel.notificationTimeAM = false
                } label: {
                    Image("gergewfwef")
                        .padding(.bottom, 6)
                        .padding(.trailing)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 100)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.gray)
        )
    }
}




#Preview {
    SettingsView()
}
