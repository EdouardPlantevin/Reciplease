//
//  RecipeProtocol.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 10/03/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation

import Alamofire

protocol RecipeProtocol {
    var urlStringApi: String { get }
    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void)
}

extension RecipeProtocol {
    var keyRecipeSearch: String {
        return Keys.keyRecipe
    }
    
    var urlStringApi: String {
        return "https://api.edamam.com/search?&app_key=\(keyRecipeSearch)&to=50&q="
    }
}

