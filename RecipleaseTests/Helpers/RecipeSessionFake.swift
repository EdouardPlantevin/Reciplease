//
//  RecipeSessionFake.swift
//  RecipleaseTests
//
//  Created by Edouard PLANTEVIN on 10/03/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation
import Alamofire
@testable import Reciplease

class RecipeSessionFake: RecipeProtocol {
    
    private let fakeResponse: FakeResponse
    
    init(fakeResponse: FakeResponse) {
        self.fakeResponse = fakeResponse
    }

    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        let httpResponse = fakeResponse.response
        let data = fakeResponse.data
        let error = fakeResponse.error
        let result = Request.serializeResponseJSON(options: .allowFragments, response: httpResponse, data: data, error: error)
        
        guard let url = createRecipeSearchUrl(ingredientsList: [String]()) else { return }
        let urlRequest = URLRequest(url: url)
        
        completionHandler(DataResponse(request: urlRequest, response: httpResponse, data: data, result: result))
    }
    
    private func createRecipeSearchUrl(ingredientsList: [String]) -> URL? {
        let ingredientUrl = ingredientsList.joined(separator: ",")
        guard let url = URL(string: urlStringApi + ingredientUrl) else { return nil }
        return url
    }
}
