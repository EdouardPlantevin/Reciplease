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
    
    func testItems_WhenAddNewItem_ThenSdouldAddNewItemToCoreData() {
  
        //Given
        let itemName = "item1"
        //Create
        ItemDataModel.saveIngredient(named: itemName)
   
        //Then
        let item = ItemDataModel.all
        var name: [String] = []
        for nameItemDataModel in item {
            if let nameAppend = nameItemDataModel.name {
                name.append(nameAppend)
            }
        }
        XCTAssertTrue(name.contains(itemName))
    }

    

    
}
