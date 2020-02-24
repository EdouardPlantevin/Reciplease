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
    static var request: NSFetchRequest<ItemDataModel> = ItemDataModel.fetchRequest()
    static var all: [ItemDataModel] {
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
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
