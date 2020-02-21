//
//  ServiceTest.swift
//  RecipleaseTests
//
//  Created by Edouard PLANTEVIN on 20/02/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation
import CoreData
@testable import Reciplease

func deleteData() {
    var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeDataModel")
    fetchRequest.returnsObjectsAsFaults = false

    do
    {
        let results = try AppDelegate.viewContext.fetch(fetchRequest)
        for managedObject in results
        {
            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
             AppDelegate.viewContext.delete(managedObjectData)
        }
    } catch let error as NSError {
        print("Error: \(error)")
    }
    
    fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ingredient")
    fetchRequest.returnsObjectsAsFaults = false

    do
    {
        let results = try AppDelegate.viewContext.fetch(fetchRequest)
        for managedObject in results
        {
            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
             AppDelegate.viewContext.delete(managedObjectData)
        }
    } catch let error as NSError {
        print("Error: \(error)")
    }
}
