//
//  Recipe.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 11/02/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation
import CoreData

class Recipe: NSManagedObject {
    static var all: [Recipe] {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        guard let recipe = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return recipe
    }
}
