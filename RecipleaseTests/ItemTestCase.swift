//
//  ItemTestCase.swift
//  RecipleaseTests
//
//  Created by Edouard PLANTEVIN on 20/02/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class ItemTestCase: XCTestCase {

    func testItem_WhenAddItem_ThenShouldReturnItems() {
        //Given
        let item = ItemDataModel(context: AppDelegate.viewContext)
        item.name = "item1"
        try? AppDelegate.viewContext.save()
        
        //Create
        let items = ItemDataModel.all
        
        if let name = items.first?.name {
            XCTAssertEqual(items.first?.name, name)
        }
    }
    
    func testItems_WhenRemoveAllItems_ThenShoulReturnEmptyArray() {
        //Given
        let item = ItemDataModel(context: AppDelegate.viewContext)
        item.name = "12345"
        try? AppDelegate.viewContext.save()
        
        //Create
        ItemDataModel.deleteAll()
        let items = ItemDataModel.all

        XCTAssertEqual(items, [])
  
    }

    

    
}
