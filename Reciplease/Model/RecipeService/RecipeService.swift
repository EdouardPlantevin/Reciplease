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
        
    private let recipeSession: RecipeProtocol
    
    init(recipeSession: RecipeProtocol = RecipeSession()) {
        self.recipeSession = recipeSession
    }
    
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
        guard let ingredientsNSSet = (recipe.ingredients?.allObjects as? [IngredientDataModel]) else { return nil }
        
        var ingredients: [String:Double] = [:]
        for ingredient in ingredientsNSSet {
            guard let nameIngredient = ingredient.name else { return nil }
            ingredients[nameIngredient] = ingredient.quantity
        }
        
        let recipeObject: RecipeObject = RecipeObject(name: name, image: image, time: time, ingredient: ingredients, url: url)
        return recipeObject
    }
    
    private func getFullURL() -> URL? {
        let ingredientsData = ItemDataModel.all
        var ingredientsArray: [String] = []
        for ingredient in ingredientsData {
            if let ingredient = ingredient.name {
               ingredientsArray.append(ingredient)
            }
        }
        let ingredientURL = ingredientsArray.joined(separator: "%20")
        guard let finalURL = URL(string: recipeSession.urlStringApi + ingredientURL) else { return nil }
        return finalURL
    }
    
    func getRecipe(callBack: @escaping (Bool) -> Void) {
        guard let url = getFullURL() else { return }
        recipeSession.request(url: url) { response in
            guard response.response?.statusCode == 200 else {
                callBack(false)
                return
            }
            guard let data = response.data else {
                callBack(false)
                return
            }
            guard let recipes = try? JSONDecoder().decode(RecipesSearch.self, from: data) else {
                print("3")
                callBack(false)
                return
            }
            var recipesFinal: [RecipeObject] = []
            for recipe in recipes.hits {
                let name = recipe.recipe.label
                let image = recipe.recipe.image ?? ""
                let time = recipe.recipe.totalTime ?? 0
                let url = recipe.recipe.url
                var ingredients: [String: Double] = [:]
                for ingredient in recipe.recipe.ingredientLines {
                    ingredients[ingredient] = 0
                }
                let recipe = RecipeObject(name: name, image: image, time: time, ingredient: ingredients, url: url)
                recipesFinal.append(recipe)
            }
            self.add(recipes: recipesFinal)
            callBack(true)
        }
    }
}
