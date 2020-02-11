//
//  DetailRecipeViewController.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 24/01/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import UIKit

class DetailRecipeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var recipe: RecipeClass? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = recipe?.label
    }
    
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
    }
    
}
