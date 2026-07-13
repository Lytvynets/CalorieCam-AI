//
//  DiaryViewModel.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 23.03.2026.
//

import Foundation
import CoreData
import SwiftUI

final class DiaryViewModel: ObservableObject {
    
    @Published var showSaveAlert = false
    @Published var showDeleteAlert = false
    @Published var NSManagedObjectIDToDelete: NSManagedObjectID?
    @Published var showAddMealView = false
    @Published var newCalories: String = ""
    @Published var newName = ""
    @Published var selectedImage: UIImage?
    @Published var foods: [FoodEntity] = []
    @Published var selectedDate: Date = Date()
    
    
    var filteredFoods: [FoodEntity] {
        foods.filter {
            Calendar.current.isDate($0.date ?? Date(), inSameDayAs: selectedDate)
        }
    }
    
    
    var totalCalories: Int {
        foods.reduce(0) { sum, food in
            if Calendar.current.isDate(food.date ?? Date(), inSameDayAs: selectedDate) {
                return sum + Int(food.calories)
            } else {
                return sum
            }
        }
    }
    
    
    private var context: NSManagedObjectContext?
    
    func setContext(_ context: NSManagedObjectContext) {
        self.context = context
        loadFoods()
    }
    
    func loadFoods() {
        guard let context = context else { return }
        let request: NSFetchRequest<FoodEntity> = FoodEntity.fetchRequest()
        do {
            foods = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func addFood(name: String, userCalories: Double, image: UIImage?) {
        guard !newName.isEmpty, let calories = Double(newCalories) else { return }
        let food = FoodEntity(context: context!)
        food.name = newName
        food.calories = calories
        food.image = selectedImage
        food.date = Date()
        showSaveAlert = true
        saveContext()
        newName = name
        newCalories = "\(userCalories)"
        selectedImage = image
        loadFoods()
    }
    
    
    func deleteFood(by id: NSManagedObjectID) {
        do {
            let food = try context!.existingObject(with: id)
            context!.delete(food)
            saveContext()
            loadFoods()
        } catch {
            print("Помилка видалення: \(error.localizedDescription)")
        }
    }
    
    
    private func saveContext() {
        if context!.hasChanges {
            do { try context!.save() }
            catch { print("Save error: \(error.localizedDescription)") }
        }
    }
    
    
    func loadFoods(sortedByName: Bool = true) {
        let request: NSFetchRequest<FoodEntity> = FoodEntity.fetchRequest()
        if sortedByName {
            request.sortDescriptors = [NSSortDescriptor(keyPath: \FoodEntity.name, ascending: true)]
        }
        do {
            foods = try context!.fetch(request)
        } catch {
            print("Fetch error: \(error.localizedDescription)")
        }
    }
    
    
    func goToPreviousDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
    }
    
    
    func goToNextDay() {
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
        if nextDay <= Date() {
            selectedDate = nextDay
        }
    }
    
    var formattedDate: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(selectedDate) {
            return "Today"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        return formatter.string(from: selectedDate)
    }
}
