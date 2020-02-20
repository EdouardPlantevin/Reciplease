//
//  Recipe.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 11/02/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation
import CoreData

class RecipeDataModel: NSManagedObject {
    static var all: [RecipeDataModel] {
        let request: NSFetchRequest<RecipeDataModel> = RecipeDataModel.fetchRequest()
        guard let recipe = try? AppDelegate.viewContext.fetch(request) else {
            return []
        }
        return recipe
    }
    
    static func removeRecipe(recipe: RecipeDataModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeDataModel")
        if let name = recipe.name {
            fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        }

        do {
            let profiles = try AppDelegate.viewContext.fetch(fetchRequest)

            if let recipe = profiles.first as? RecipeDataModel {
                AppDelegate.viewContext.delete(recipe)
                try? AppDelegate.viewContext.save()
            } else {
                // no local cache yet, use placeholder for now
            }
        } catch {
            // handle error
        }
    }
    
    static func addRecipe(recipe: RecipeObject) -> RecipeDataModel {
        let recipeToAdd = RecipeDataModel(context: AppDelegate.viewContext)
        let name = recipe.name
        let likes = recipe.likes
        let time = recipe.time
        let image = recipe.image
        let url = recipe.url
        recipeToAdd.name = name
        recipeToAdd.likes = likes
        recipeToAdd.time = Double(time)
        recipeToAdd.image = image
        recipeToAdd.url = url
        try? AppDelegate.viewContext.save()
        
        let ingredients = recipe.ingredient
        for ingredient in ingredients {
            let ingredientToSave = Ingredient(context: AppDelegate.viewContext)
            ingredientToSave.quantity = ingredient.value
            ingredientToSave.name = ingredient.key
            ingredientToSave.recipe = recipeToAdd
            try? AppDelegate.viewContext.save()
        }
        return recipeToAdd
    }
}
