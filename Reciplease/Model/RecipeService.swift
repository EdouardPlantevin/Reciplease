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
    
    private(set) var recipes: Recipe?
    
    func add(recipes: Recipe) {
        self.recipes = recipes
    }
    
    
    
    private let baseURL = "https://api.edamam.com/search?"
    
    private func getFullURL() -> String {
        let ingredientsData = Ingredient.all
        var ingredientsArray: [String] = []
        for ingredient in ingredientsData {
            if let ingredient = ingredient.name {
               ingredientsArray.append(ingredient)
            }
        }
        let ingredientURL = ingredientsArray.joined(separator: "%20")
        let keyURL = Key.keyRecipe
        let finalURL = baseURL + "q=" + ingredientURL + "&app_key=" + keyURL
        return finalURL
    }
    
    func getRecipe(callBack: @escaping (Bool,Recipe?) -> Void) {
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
                        let recipe = try jsonDecoder.decode(Recipe.self, from: jsonData)
                        if recipe.count > 0 {
                            callBack(true, recipe)
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
