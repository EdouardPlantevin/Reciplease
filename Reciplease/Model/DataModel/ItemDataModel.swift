//
//  Ingredient.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 23/01/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation
import CoreData

class ItemDataModel: NSManagedObject {
    static var all: [ItemDataModel] {
        let request: NSFetchRequest<ItemDataModel> = ItemDataModel.fetchRequest()
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
    }
    
    static func saveIngredient(named name: String) {
        let ingredient = ItemDataModel(context: AppDelegate.viewContext)
        ingredient.name = name
        try? AppDelegate.viewContext.save()
    }
    
    static func deleteAll() {
        let context = AppDelegate.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemDataModel")
        fetchRequest.returnsObjectsAsFaults = false

        let results = try? context.fetch(fetchRequest)
        if let results = results {
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                }
            }
            try? AppDelegate.viewContext.save()
        }
    }
    
}
