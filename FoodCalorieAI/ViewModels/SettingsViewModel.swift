//
//  SettingsViewModel.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 22.03.2026.
//

import Foundation
import UIKit
import StoreKit

class SettingsViewModel: ObservableObject {
    
    @Published var notificationHours: Int {
        didSet {
            UserDefaults.standard.set(notificationHours, forKey: "notificationHours")
        }
    }
    
    @Published var notificationMinutes: Int {
        didSet {
            UserDefaults.standard.set(notificationMinutes, forKey: "notificationMinutes")
        }
    }
    
    @Published var notificationTimeAM: Bool {
        didSet {
            UserDefaults.standard.set(notificationTimeAM, forKey: "notificationTimeAM")
        }
    }
    
  
    @Published var notificationsIsOn: Bool {
        didSet {
            UserDefaults.standard.set(notificationsIsOn, forKey: "notificationsIsOn")
        }
    }
    
    
    @Published var showShareSheet = false
    @Published var responseLanguage = "English"
    
    @Published var languages: [Language] = [
        Language(flag: "🇸🇦", name: "Arabic"),
        Language(flag: "🇮🇩", name: "Bahasa Indonesia"),
        Language(flag: "🇨🇳", name: "Chinese"),
        Language(flag: "🇨🇿", name: "Czech"),
        Language(flag: "🇩🇰", name: "Danish"),
        Language(flag: "🇳🇱", name: "Dutch"),
        Language(flag: "🇬🇧", name: "English"),
        Language(flag: "🇵🇭", name: "Filipino"),
        Language(flag: "🇫🇮", name: "Finnish"),
        Language(flag: "🇫🇷", name: "French"),
        Language(flag: "🇩🇪", name: "German"),
        Language(flag: "🇬🇷", name: "Greek"),
        Language(flag: "🇮🇱", name: "Hebrew"),
        Language(flag: "🇮🇳", name: "Hindi"),
        Language(flag: "🇭🇺", name: "Hungarian"),
        Language(flag: "🇮🇸", name: "Icelandic"),
        Language(flag: "🇮🇹", name: "Italian"),
        Language(flag: "🇯🇵", name: "Japanese"),
        Language(flag: "🇰🇷", name: "Korean"),
        Language(flag: "🇲🇾", name: "Malay"),
        Language(flag: "🇳🇴", name: "Norwegian"),
        Language(flag: "🇵🇱", name: "Polish"),
        Language(flag: "🇵🇹", name: "Portuguese"),
        Language(flag: "🇷🇴", name: "Romanian"),
        Language(flag: "🇷🇺", name: "Russian"),
        Language(flag: "🇸🇰", name: "Slovak"),
        Language(flag: "🇸🇮", name: "Slovenian"),
        Language(flag: "🇪🇸", name: "Spanish"),
        Language(flag: "🇸🇪", name: "Swedish"),
        Language(flag: "🇹🇭", name: "Thai"),
        Language(flag: "🇹🇷", name: "Turkish"),
        Language(flag: "🇺🇦", name: "Ukrainian"),
        Language(flag: "🇵🇰", name: "Urdu"),
        Language(flag: "🇻🇳", name: "Vietnamese"),
        Language(flag: "🇭🇷", name: "Croatian"),
        Language(flag: "🇧🇬", name: "Bulgarian"),
        Language(flag: "🇪🇪", name: "Estonian"),
        Language(flag: "🇱🇻", name: "Latvian"),
        Language(flag: "🇱🇹", name: "Lithuanian"),
        Language(flag: "🇧🇩", name: "Bengali")
    ]
    
    
    
    init() {
        let responseLanguage = UserDefaults.standard.string(forKey: "responseLanguages") ?? "English"
        let notificationsIsOn = UserDefaults.standard.object(forKey: "notificationsIsOn") as? Bool ?? false
        let notificationTimeAM = UserDefaults.standard.object(forKey: "notificationTimeAM") as? Bool ?? false
        let notificationHours = UserDefaults.standard.object(forKey: "notificationHours") as? Int ?? 12
        let notificationMinutes = UserDefaults.standard.object(forKey: "notificationMinutes")  as? Int ?? 0
        self.responseLanguage = responseLanguage
        self.notificationsIsOn = notificationsIsOn
        self.notificationTimeAM = notificationTimeAM
        self.notificationHours = notificationHours
        self.notificationMinutes = notificationMinutes
    }
    
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    
}




