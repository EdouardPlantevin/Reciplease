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
    var recipe: Recipe?
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
        let recipeToAdd = Recipe(context: AppDelegate.viewContext)
        guard let name = recipe?.name else { return }
        guard let likes = recipe?.likes else { return }
        guard let time = recipe?.time else { return }
        guard let image = recipe?.image else { return }
        recipeToAdd.name = name
        recipeToAdd.likes = likes
        recipeToAdd.time = Double(time)
        recipeToAdd.image = image
        try? AppDelegate.viewContext.save()
        
        guard let ingredients = recipe?.ingredient else { return }
        for ingredient in ingredients {
            let ingredientToSave = Ingredient(context: AppDelegate.viewContext)
            ingredientToSave.quantity = ingredient.value
            ingredientToSave.name = ingredient.key
            ingredientToSave.recipe = recipeToAdd
            try? AppDelegate.viewContext.save()
        }
        self.recipe = recipeToAdd
        changeBtnImageFavorite(fav: true)
        isFavorite = true
    }
    
    private func deleteRecipe(recipe: Recipe) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        if let name = recipe.name {
            fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        }

        do {
            let profiles = try AppDelegate.viewContext.fetch(fetchRequest)

            if let recipe = profiles.first as? Recipe {
                AppDelegate.viewContext.delete(recipe)
                try? AppDelegate.viewContext.save()
                changeBtnImageFavorite(fav: false)
                if let index = self.index {
                    RecipeService.shared.delete(index: index)
                }
                changeBtnImageFavorite(fav: false)
                isFavorite = false
            } else {
                // no local cache yet, use placeholder for now
            }
        } catch {
            // handle error
        }
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
 
    
}
