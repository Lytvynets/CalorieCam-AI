//
//  PersistenceController.swift
//  FoodCalorieAI
//
//  Created by Vlad Lytvynets on 23.03.2026.
//

import Foundation
import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FoodModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data store failed: \(error)")
            }
        }
    }
}

@objc(FoodEntity)
public class FoodEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntity> {
        return NSFetchRequest<FoodEntity>(entityName: "FoodEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var calories: Double
    @NSManaged public var imageData: Data?
    @NSManaged public var date: Date
    
    var image: UIImage? {
        get {
            guard let data = imageData else { return nil }
            return UIImage(data: data)
        }
        set {
            imageData = newValue?.jpegData(compressionQuality: 0.8)
        }
    }
}

extension FoodEntity: Identifiable {}
