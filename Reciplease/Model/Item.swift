//
//  Ingredient.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 23/01/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {
    static var all: [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        guard let items = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return items
    }
    
    static func deleteAll() {
        let context = AppDelegate.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                }
            }
            try? AppDelegate.viewContext.save()
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
}
