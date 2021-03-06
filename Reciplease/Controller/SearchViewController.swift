//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 23/01/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var textfieldIngredient: UITextField!
    @IBOutlet weak var listIngredient: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchRecipeBtn: UIButton!
    
    var recipeService = RecipeService()
    
    // Use for ingredient display
    var ingredients: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textfieldIngredient.delegate = self
        displayIngredientsList()
        activityIndicator.isHidden = true
    }

    
    
    //MARK: Button
    @IBAction func addIngredientBtn(_ sender: UIButton) {
        addIngredient()
        textfieldIngredient.resignFirstResponder()
    }
    @IBAction func clearBtn(_ sender: UIButton) {
        ItemDataModel.deleteAll()
        displayIngredientsList()
        ingredients.removeAll()
    }
    
    @IBAction func searchRecipeBtn(_ sender: UIButton) {
        showActivityIndicator()
        activityIndicator.startAnimating()
        recipeService.getRecipe { (success) in
            if success {
                self.showActivityIndicator()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as! RecipeViewController
                vc.recipeService = self.recipeService
                vc.currentPage = .search
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                presentAlert(view: self, message: "No recipe found\ncheck spelling")
                self.showActivityIndicator()
            }
        }
    }
    
     //MARK:  Private Function
    private func showActivityIndicator() {
        searchRecipeBtn.isHidden = !searchRecipeBtn.isHidden
        activityIndicator.isHidden = !activityIndicator.isHidden
    }
    
    fileprivate func displayIngredientsList() {
        var ingredientText = ""
        for ingredient in ItemDataModel.all {
            if let name = ingredient.name {
                ingredientText += "  - " + name + "\n"
                ingredients.append(name)
            }
        }
        listIngredient.text = ingredientText
    }
    
    private func addIngredient() {
        if textfieldIngredient.text != nil && textfieldIngredient.text != "" {
            if let ingredient = textfieldIngredient.text?.trimmingCharacters(in: .whitespaces) {
                if ingredients.contains(ingredient) {
                    presentAlert(view: self, message: "You already put it")
                } else {
                    listIngredient.text += "  - \(ingredient)\n"
                    ItemDataModel.saveIngredient(named: ingredient)
                    ingredients.append(ingredient)
                }
            }
        } else {
            presentAlert(view: self, message: "You try to add nothing ? go to the supermarket bro\nWe can't do anything for you here")
        }
        textfieldIngredient.text = ""
    }
}

// MARK: Extention

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredient()
        self.view.endEditing(true)
        return false
    }
}
