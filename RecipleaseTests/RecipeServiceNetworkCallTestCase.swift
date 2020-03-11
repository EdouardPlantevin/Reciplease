//
//  RecipeAlamofire.swift
//  RecipleaseTests
//
//  Created by Edouard PLANTEVIN on 10/03/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation
import XCTest
import Alamofire
@testable import Reciplease


class RecipeServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    var ingredientsList: [String]!
    
    // MARK: - Tests Life Cycle
    
    override func setUp() {
        super.setUp()
        ingredientsList = ["Lemon", "Chicken"]
    }
    
    // MARK: - Tests
    
    func testGetRecipesShouldPostFailedCallback() {
        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeResponseData.networkError)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeService = RecipeService(recipeSession: recipeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipe { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipesShouldPostFailedCallbackIfNoData() {
        let fakeResponse = FakeResponse(response: nil, data: FakeResponseData.incorrectData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeService = RecipeService(recipeSession: recipeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipe { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
  
    func testGetRecipesShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeService = RecipeService(recipeSession: recipeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipe { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
 
    func testGetRecipesShouldPostFailedCallbackIfResponseCorrectAndDataNil() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: nil, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeService = RecipeService(recipeSession: recipeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipe { (success) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipesShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeService = RecipeService(recipeSession: recipeSessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipe { (success) in
            XCTAssertFalse(success)
             expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeService = RecipeService(recipeSession: recipeSessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipe { (success) in
            XCTAssertTrue(success)
            let name = recipeService.recipes?[0].name
            let image = recipeService.recipes?[0].image
            XCTAssertEqual(name, "Chicken Vesuvio")
            XCTAssertEqual(image, "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeShouldPostSuccessCallbackIfNoErrorAndCorrectDataAndCorrectItem() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData, error: nil)
        let recipeSessionFake = RecipeSessionFake(fakeResponse: fakeResponse)
        let recipeService = RecipeService(recipeSession: recipeSessionFake)
        
        let ingredient = ItemDataModel(context: AppDelegate.viewContext)
        ingredient.name = "Chicken"
        try? AppDelegate.viewContext.save()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        recipeService.getRecipe { (success) in
            XCTAssertTrue(success)
            let name = recipeService.recipes?[0].name
            let image = recipeService.recipes?[0].image
            XCTAssertEqual(name, "Chicken Vesuvio")
            XCTAssertEqual(image, "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg")
            ItemDataModel.deleteAll()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

}
