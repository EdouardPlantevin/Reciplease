//
//  RecipeService.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 10/02/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation
import Alamofire

class RecipeService {
    
    static let shared = RecipeService()
    private init() {}
    
    private(set) var recipes: [RecipeObject]?
    
    func add(recipes: [RecipeObject]) {
        self.recipes = recipes
    }
    
    func delete(index: Int) {
        self.recipes?.remove(at: index)
    }
    
    static func convertRecipeToRecipeObject(recipe: RecipeDataModel) -> RecipeObject? {
        guard let name = recipe.name else { return nil }
        guard let image = recipe.image else { return nil }
        guard let url = recipe.url else { return nil }
        let time = Int(recipe.time)
        guard let ingredientsNSSet = (recipe.ingredients?.allObjects as? [Ingredient]) else { return nil}
        
        var ingredients: [String:Double] = [:]
        for ingredient in ingredientsNSSet {
            guard let nameIngredient = ingredient.name else { return nil }
            ingredients[nameIngredient] = ingredient.quantity
        }
        
        let recipeObject: RecipeObject = RecipeObject(name: name, image: image, time: time, ingredient: ingredients, url: url)
        return recipeObject
    }
    
    
    
    private let baseURL = "https://api.edamam.com/search?"
    
    private func getFullURL() -> String {
        let ingredientsData = Item.all
        var ingredientsArray: [String] = []
        for ingredient in ingredientsData {
            if let ingredient = ingredient.name {
               ingredientsArray.append(ingredient)
            }
        }
        let ingredientURL = ingredientsArray.joined(separator: "%20")
        let keyURL = Keys.keyRecipe
        let finalURL = baseURL + "q=" + ingredientURL + "&app_key=" + keyURL
        return finalURL
    }
    
    
    
    
    func getRecipe(callBack: @escaping (Bool,[RecipeObject]?) -> Void) {
        let url = getFullURL()
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
                case .success:
                    guard let jsonData = response.data else {
                        callBack(false, nil)
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    do {
                        let recipes = try jsonDecoder.decode(RecipeFromJson.self, from: jsonData)
                        if recipes.count > 0 {
                            var recipesFinal: [RecipeObject] = []
                            for recipe in recipes.hits {
                                let name = recipe.recipe.label
                                let image = recipe.recipe.image
                                let time = recipe.recipe.totalTime
                                let url = recipe.recipe.url
                                var ingredients: [String: Double] = [:]
                                for ingredient in recipe.recipe.ingredients {
                                    ingredients[ingredient.text] = ingredient.weight
                                }
                                let recipe = RecipeObject(name: name, image: image, time: time, ingredient: ingredients, url: url)
                                recipesFinal.append(recipe)
                            }
                            callBack(true, recipesFinal)
                        } else {
                            callBack(false, nil)
                        }
                    } catch let error{
                        print(error.localizedDescription)
                        callBack(false, nil)
                    }
                      
                case .failure(let error):
                    print(error.localizedDescription)
                    callBack(false, nil)
            }
        }
    }
    
}
