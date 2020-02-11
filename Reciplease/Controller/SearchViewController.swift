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
    
    var ingredients: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textfieldIngredient.delegate = self
        displayPeopleList()
    }
    
    
    //MARK: Button
    @IBAction func addIngredientBtn(_ sender: UIButton) {
        addIngredient()
        textfieldIngredient.resignFirstResponder()
    }
    @IBAction func clearBtn(_ sender: UIButton) {
        Ingredient.deleteAll()
        displayPeopleList()
        ingredients.removeAll()
    }
    
    @IBAction func searchRecipeBtn(_ sender: UIButton) {
        RecipeService.shared.getRecipe { (success, recipe) in
            if success {
                RecipeService.shared.add(recipes: recipe!)
                print(recipe!.hits.first!.recipe.label)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "recipeViewController") as! RecipeViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                print("erreur")
            }
        }
    }
    
    //MARK: Function
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let actionn = UIAlertAction(title: "WTF", style: .destructive, handler: nil)
        alertVC.addAction(actionn)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    

    //MARK:  Private Function
    fileprivate func displayPeopleList() {
        var ingredientText = ""
        for ingredient in Ingredient.all {
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
                showAlert(title: "Bro ?", message: "You already put it")
            } else {
                guard let ingredientName = textfieldIngredient.text else {
                    return
                }
                listIngredient.text += "  - \(ingredientName)\n"
                saveIngredient(named: ingredientName)
                ingredients.append(ingredientName)
            }
        } else {
            showAlert(title: "Hum", message: "You try to add nothing ? go to the supermarket bro\nWe can't do anything for you here")
        }
        textfieldIngredient.text = ""
    }
    
    private func saveIngredient(named name: String) {
        let ingredient = Ingredient(context: AppDelegate.viewContext)
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
