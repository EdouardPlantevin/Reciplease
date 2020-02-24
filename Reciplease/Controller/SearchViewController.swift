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
        RecipeService.shared.getRecipe { (success, recipe) in
            if success {
                RecipeService.shared.add(recipes: recipe!)
                self.showActivityIndicator()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as! RecipeViewController
                vc.currentPage = .search
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                presentAlert(view: self, message: "No recipe found\ncheck spelling")
                self.showActivityIndicator()
            }
        }
    }
    
    //MARK: Function
    private func showActivityIndicator() {
        searchRecipeBtn.isHidden = !searchRecipeBtn.isHidden
        activityIndicator.isHidden = !activityIndicator.isHidden
    }
    

    //MARK:  Private Function
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
            if ingredients.contains(textfieldIngredient.text!) {
                presentAlert(view: self, message: "You already put it")
            } else {
                guard let ingredientName = textfieldIngredient.text else {
                    return
                }
                listIngredient.text += "  - \(ingredientName)\n"
                saveIngredient(named: ingredientName)
                ingredients.append(ingredientName)
            }
        } else {
            presentAlert(view: self, message: "You try to add nothing ? go to the supermarket bro\nWe can't do anything for you here")
        }
        textfieldIngredient.text = ""
    }
    
    private func saveIngredient(named name: String) {
        let ingredient = ItemDataModel(context: AppDelegate.viewContext)
        ingredient.name = name
        try? AppDelegate.viewContext.save()
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
