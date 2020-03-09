//
//  RecipeServiceTestCase.swift
//  RecipleaseTests
//
//  Created by Edouard PLANTEVIN on 20/02/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeServiceTestCase: XCTestCase {

    
    func testRecipeService_WhenAddIRecipe_ThenShouldReturnRecipe() {
        //Given
        let recipeObject = RecipeObject(name: "", image: "", time: 0, ingredient: [:], url: "")
        RecipeService.shared.add(recipes: [recipeObject])

        let recipes = RecipeService.shared.recipes
        XCTAssertEqual(recipes?.count, 1)
        
    }
    
    func testRecipeService_WhenRemoveIRecipe_ThenShouldReturnEmptyArray() {
        //Given
        let recipeObject = RecipeObject(name: "", image: "", time: 0, ingredient: [:], url: "")
        RecipeService.shared.add(recipes: [recipeObject])

        RecipeService.shared.delete(index: 0)
        
        let recipes = RecipeService.shared.recipes
        XCTAssertEqual(recipes?.count, 0)
        
    }
    
    func testRecipeService_WhenConvertRecipeDataModel_ThenShouldReturnRecipeObject() {
        deleteData()
         //Given
        let recipeDataModel = RecipeDataModel(context: AppDelegate.viewContext)
        recipeDataModel.name = "name"
        recipeDataModel.image = ""
        recipeDataModel.likes = 1.0
        recipeDataModel.time = 1.0
        recipeDataModel.url = ""
        
        let ingredient = IngredientDataModel(context: AppDelegate.viewContext)
        ingredient.name = ""
        ingredient.quantity = 1.0
        ingredient.recipe = recipeDataModel
        
        let recipeObject = RecipeService.convertRecipeToRecipeObject(recipe: recipeDataModel)
        
        XCTAssertNotNil(recipeObject)
        deleteData()
     }
    
    func testRecipeService_WhenConvertRecipeDataModelWithoutName_ThenShouldReturnNil() {
        deleteData()
         //Given
        let recipeDataModel = RecipeDataModel(context: AppDelegate.viewContext)
        
        let recipeObject = RecipeService.convertRecipeToRecipeObject(recipe: recipeDataModel)
        
        XCTAssertNil(recipeObject)
        deleteData()
     }
    
    func testRecipeService_WhenConvertRecipeDataModelWithoutImage_ThenShouldReturnNil() {
        deleteData()
         //Given
        let recipeDataModel = RecipeDataModel(context: AppDelegate.viewContext)
        recipeDataModel.name = "name"
        let recipeObject = RecipeService.convertRecipeToRecipeObject(recipe: recipeDataModel)
        
        XCTAssertNil(recipeObject)
        deleteData()
     }
    
    func testRecipeService_WhenConvertRecipeDataModelWithoutUrl_ThenShouldReturnNil() {
        deleteData()
         //Given
        let recipeDataModel = RecipeDataModel(context: AppDelegate.viewContext)
        recipeDataModel.name = "name"
        recipeDataModel.image = ""
        let recipeObject = RecipeService.convertRecipeToRecipeObject(recipe: recipeDataModel)
        
        XCTAssertNil(recipeObject)
        deleteData()
     }
    
    func testRecipeService_WhenConvertRecipeDataModelWithoutIngredientName_ThenShouldReturnNil() {
        deleteData()
         //Given
        let recipeDataModel = RecipeDataModel(context: AppDelegate.viewContext)
        recipeDataModel.name = "name"
        recipeDataModel.image = ""
        recipeDataModel.likes = 1.0
        recipeDataModel.time = 1.0
        recipeDataModel.url = ""
        
        let ingredient = IngredientDataModel(context: AppDelegate.viewContext)
        ingredient.quantity = 1.0
        ingredient.recipe = recipeDataModel
        
        let recipeObject = RecipeService.convertRecipeToRecipeObject(recipe: recipeDataModel)
        
        XCTAssertNil(recipeObject)
        deleteData()
     }
    
    
    
    //Alamofire
    
    
    func testRecipeService_WhenCallFuncGetRecipe_ThenShouldReturnRecipeAndSuccessTrue() {
        let e = expectation(description: "Alamofire")
        let ingredient = ItemDataModel(context: AppDelegate.viewContext)
        ingredient.name = "chicken"
        try? AppDelegate.viewContext.save()
        RecipeService.shared.getRecipe { (success) in
            XCTAssertNotNil(RecipeService.shared.recipes)
            XCTAssertTrue(success)
            e.fulfill()
            ItemDataModel.deleteAll()
        }
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testRecipeService_WhenCallFuncGetRecipeWithoutItem_ThenShouldReturnNoRecipeAndSuccessFalse() {
        ItemDataModel.deleteAll()
        let e = expectation(description: "Alamofire")
        RecipeService.shared.getRecipe { (success) in
            XCTAssertFalse(success)
            e.fulfill()
        
        }
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testRecipeService_WhenCallFuncGetRecipeWithWrongItem_ThenShouldReturnNotRecipeAndSuccessfalse() {
        let e = expectation(description: "Alamofire")
        let ingredient = ItemDataModel(context: AppDelegate.viewContext)
        ingredient.name = "test"
        try? AppDelegate.viewContext.save()
        RecipeService.shared.getRecipe { (success) in
            XCTAssertFalse(success)
            e.fulfill()
            ItemDataModel.deleteAll()
        }
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testRecipeService_WhenCallFuncGetRecipeWithWrongItemEspace_ThenShouldReturnNotRecipeAndSuccessfalse() {
         let e = expectation(description: "Alamofire")
         let ingredient = ItemDataModel(context: AppDelegate.viewContext)
         ingredient.name = "test "
         try? AppDelegate.viewContext.save()
         RecipeService.shared.getRecipe { (success) in
             XCTAssertFalse(success)
             e.fulfill()
             ItemDataModel.deleteAll()
         }
         waitForExpectations(timeout: 15.0, handler: nil)
     }


    

}
