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
                                var ingredients: [String: Double] = [:]
                                for ingredient in recipe.recipe.ingredients {
                                    ingredients[ingredient.text] = ingredient.weight
                                }
                                let recipe = RecipeObject(name: name, image: image, time: time, ingredient: ingredients)
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
