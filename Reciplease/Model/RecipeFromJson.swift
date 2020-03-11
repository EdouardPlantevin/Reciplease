//
//  Recipe.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 10/02/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation

struct RecipeObject {
    let name: String
    let image: String
    let time: Int
    let likes = 2.5
    let ingredient: [String: Double]
    let url: String
}

struct RecipesSearch: Decodable {
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Decodable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Decodable {
    let label: String
    let image: String?
    let url: String
    let yield: Int
    let ingredientLines: [String]
    let totalTime: Int?
}

