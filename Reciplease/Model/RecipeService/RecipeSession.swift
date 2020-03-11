//
//  RecipeSession.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 10/03/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation
import Alamofire

class RecipeSession: RecipeProtocol {
    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        Alamofire.request(url).responseJSON { responseData in
            completionHandler(responseData)
        }
    }
}
