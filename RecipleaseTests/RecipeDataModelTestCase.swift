//
//  RecipeDataModelTestCase.swift
//  RecipleaseTests
//
//  Created by Edouard PLANTEVIN on 20/02/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeDataModelTestCase: XCTestCase {

    func testRecipeDataModel_WhenRemoveRecipe_ThenShouldReturnFalse() {
        deleteData()
        let recipeDataModel = RecipeDataModel(context: AppDelegate.viewContext)
        recipeDataModel.name = "name"
        
        try? AppDelegate.viewContext.save()
        
        RecipeDataModel.removeRecipe(recipe: recipeDataModel)
        
        XCTAssertFalse(RecipeDataModel.all.contains(recipeDataModel))
        deleteData()
    }
    
    func testRecipeDataModel_WhenAddRecipeFromRecipeObject_ThenShouldReturnRecipeDataModel() {
        deleteData()
        let recipeObject = RecipeObject(name: "", image: "", time: 1, ingredient: ["Name":1], url: "")
        
        let recipeDataModel = RecipeDataModel.addRecipe(recipe: recipeObject)
        XCTAssertNotNil(recipeDataModel)
        deleteData()
    }

}
