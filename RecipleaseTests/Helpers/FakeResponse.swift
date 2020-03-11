//
//  FakeResponse.swift
//  RecipleaseTests
//
//  Created by Edouard PLANTEVIN on 10/03/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation

struct FakeResponse {
    var response: HTTPURLResponse?
    var data: Data?
    var error: Error?
}
