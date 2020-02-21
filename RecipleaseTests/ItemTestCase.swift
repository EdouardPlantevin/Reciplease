//
//  ItemTestCase.swift
//  RecipleaseTests
//
//  Created by Edouard PLANTEVIN on 20/02/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import XCTest
@testable import Reciplease

class ItemTestCase: XCTestCase {

    func testItem_WhenAddItem_ThenShouldReturnItems() {
        //Given
        let ingredient = Item(context: AppDelegate.viewContext)
        ingredient.name = "item1"
        try? AppDelegate.viewContext.save()
        
        //Create
        let items = Item.all
        
        if let name = items.first?.name {
            XCTAssertEqual(items.first?.name, name)
        }
    }
    
    func testItems_WhenRemoveAllItems_ThenShoulReturnEmptyArray() {
        //Given
        let ingredient = Item(context: AppDelegate.viewContext)
        ingredient.name = "12345"
        try? AppDelegate.viewContext.save()
        
        //Create
        Item.deleteAll()
        let items = Item.all

        XCTAssertEqual(items, [])
  
    }
    
}
