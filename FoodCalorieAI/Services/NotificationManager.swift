//
//  NotificationManager.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 24.03.2026.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Permission granted")
                
                UserDefaults.standard.set(true, forKey: "notificationsIsOn")
            } else {
                UserDefaults.standard.set(false, forKey: "notificationsIsOn")
                print("❌ Permission denied")
            }
        }
    }
    
    func scheduleDailyNotification(timeString: String) {
        let components = parseTime(timeString: timeString)
        guard let hour = components?.hour,
              let minute = components?.minute else {
            print("❌ Invalid time format")
            return
        }
        
        let messages = [
            "Don't forget to write down what you ate 🍔",
            "Time to add calories 🔥",
            "Your tracking is waiting for you 📊",
            "Add your meal 🍽",
            "Calorie control = results 💪"
        ]
        
        let randomMessage = messages.randomElement() ?? "Reminder"
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = randomMessage
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: "daily_notification",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func disableNotifications() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["daily_notification"])
    }
    
    private func parseTime(timeString: String) -> DateComponents? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        guard let date = formatter.date(from: timeString) else {
            return nil
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        return components
    }
}
