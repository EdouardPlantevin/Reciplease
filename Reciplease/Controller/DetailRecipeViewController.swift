//
//  DetailRecipeViewController.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 24/01/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import UIKit
import CoreData

class DetailRecipeViewController: UIViewController {
    
    enum page {
        case search
        case favorite
    }
    
    var currentPage: page = .favorite
    var recipe: RecipeDataModel?
    var recipeObject: RecipeObject?
    var index: Int?
    var isFavorite: Bool = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var favorityOutlet: UIBarButtonItem!
    @IBOutlet weak var favorityBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let recipe = recipeObject {
            setPage(recipe: recipe)
        }
        if currentPage == .favorite {
            changeBtnImageFavorite(fav: true)
            isFavorite = true
        }
    }
    
    private func setPage(recipe: RecipeObject) {
        nameLabel.text = recipe.name
        var ingredientsLabel = ""
        for ingredient in recipe.ingredient {
            ingredientsLabel += "- \(Int(ingredient.value))  \(ingredient.key)\n"
        }
        ingredientsTextView.text = ingredientsLabel
        let imageURL = recipe.image
        let url = URL(string: imageURL)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)!
        imageRecipe.image = image
    }
    
    private func changeBtnImageFavorite(fav: Bool) {
        if fav {
            favorityBtnOutlet.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favorityBtnOutlet.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    private func addFavoriteRecipeObject(recipe: RecipeObject?) {
        if let recipe = recipe {
            self.recipe = RecipeDataModel.addRecipe(recipe: recipe)
            changeBtnImageFavorite(fav: true)
            isFavorite = true
        }
    }
    
    private func deleteRecipe(recipe: RecipeDataModel) {
        RecipeDataModel.removeRecipe(recipe: recipe)
        if let index = self.index {
            RecipeService.shared.delete(index: index)
        }
        changeBtnImageFavorite(fav: false)
        isFavorite = false
    }

    @IBAction func addToFavority(_ sender: UIButton) {
        if isFavorite {
            ///Remove
            if let recipe = self.recipe {
                deleteRecipe(recipe: recipe)
            }
        } else {
            ///Add
            addFavoriteRecipeObject(recipe: self.recipeObject)
        }
    }
    
    @IBAction func getDirectionBtn(_ sender: UIButton) {
        if let url = URL(string: "\(recipeObject?.url ?? "https://www.google.com")"),
                UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
        }
    }
    
    
}
