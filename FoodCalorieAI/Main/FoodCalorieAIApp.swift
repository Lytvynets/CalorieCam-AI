//
//  FoodCalorieAIApp.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 31.07.2025.
//

import SwiftUI
import CoreData

enum Tabs {
    case scan, diary, profile, settings
}

@main
struct FoodCalorieAIApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @State private var selectedTab: Tabs = .scan
    @State private var previousTab: Tabs = .scan
    @State private var isLoaded = false
    
    @StateObject private var router = Router()
    @StateObject private var cameraManager = CameraManager()
    @StateObject private var openAIService = OpenAIService()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var inAppPurchaseViewModel = InAppPurchaseViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var diaryViewModel = DiaryViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                if isLoaded {
                    ZStack {
                        tabBar
                            .navigationDestination(for: AppRoute.self) { route in
                                switch route {
                                case .camera:
                                    CameraView()
                                case .scanResultView:
                                    ScanResultView()
                                case .recommendationView:
                                    RecommendationView()
                                case .responseLanguageView:
                                    ResponseLanguageView()
                                }
                            }
                        
                        if onboardingViewModel.showOnboarding {
                            OnboardingView()
                                .onAppear {
                                    let didSeeOnboarding = UserDefaults.standard.bool(forKey: "didSeeOnboarding")
                                    if didSeeOnboarding {
                                        onboardingViewModel.showOnboarding = false
                                    }
                                    
                                    @AppStorage("dailyNotificationsEnabled")
                                    var notificationsEnabled: Bool = true
                                    
                                    if notificationsEnabled {
                                        NotificationManager.shared.requestPermission()
                                        NotificationManager.shared.scheduleDailyNotification(timeString: "12:00 PM")
                                    }
                                }
                        }else{
                            if onboardingViewModel.showPaywall {
                                OnboardingPaywall()
                                    .onDisappear {
                                        Task {
                                            for sub in inAppPurchaseViewModel.products {
                                                inAppPurchaseViewModel.isSubscribed = await inAppPurchaseViewModel.checkSubscriptionStatus(for: sub.id)
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }else{
                    SplashScreen()
                        .onAppear {
                            let didSeeOnboarding = UserDefaults.standard.bool(forKey: "didSeeOnboarding")
                            if didSeeOnboarding {
                                onboardingViewModel.showOnboarding = false
                            }
                            Task {
                                await inAppPurchaseViewModel.fetchProducts()
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                isLoaded = true
                                
                                Task {
                                    for sub in inAppPurchaseViewModel.products {
                                        inAppPurchaseViewModel.isSubscribed = await inAppPurchaseViewModel.checkSubscriptionStatus(for: sub.id)
                                    }
                                    
                                    let didSeeOnboarding = UserDefaults.standard.bool(forKey: "didSeeOnboarding")
                                    if didSeeOnboarding {
                                        if !inAppPurchaseViewModel.isSubscribed {
                                            withAnimation(.easeInOut) {
                                                onboardingViewModel.showPaywall = true
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                }
            }
            .environment(\.managedObjectContext,
                          persistenceController.container.viewContext)
            .environmentObject(cameraManager)
            .environmentObject(router)
            .environmentObject(openAIService)
            .environmentObject(onboardingViewModel)
            .environmentObject(settingsViewModel)
            .environmentObject(inAppPurchaseViewModel)
            .environmentObject(profileViewModel)
            .environmentObject(diaryViewModel)
            .fullScreenCover(isPresented: $inAppPurchaseViewModel.showInAppPaywall) {
                InAppPaywallView()
                    .environmentObject(inAppPurchaseViewModel)
            }
        }
    }
    
    
    private var tabBar: some View {
        TabView(selection: $selectedTab) {
            
            Tab("", image: selectedTab == .scan ? "material-symbols_add-a-photo-outline" : "material-symbols_add-a-photo-outlineN", value: .scan) {
                ScanFoodView()
            }
            
            Tab("", image: selectedTab == .diary ? "mingcute_diary-line" : "mingcute_diary-lineN", value: .diary) {
                DiaryView()
            }
            
            Tab("", image: selectedTab == .profile ? "si_user-alt-6-line" : "si_user-alt-6-lineN", value: .profile) {
                ProfileView()
            }
            
            Tab("", image: selectedTab == .settings ? "cil_settings" : "cil_settingsN", value: .settings) {
                SettingsView()
            }
        }
    }
}
