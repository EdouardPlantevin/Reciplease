//
//  RecipeViewController.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 23/01/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    enum page {
        case search
        case favorite
    }
    
    var currentPage: page = .favorite
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientViewCell: UIView!
    @IBOutlet weak var titleRecipeLabel: UILabel!
    @IBOutlet weak var detailRecipeLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    // MARK: - Func ViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

}


// MARK: - TableView Recipe
extension RecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Height cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailRecipeViewController") as! DetailRecipeViewController
        var selectedRecipeObject: RecipeObject!
        
        if currentPage == .search {
            if let recipe = RecipeService.shared.recipes?[indexPath.row] {
                selectedRecipeObject = recipe
            }
            vc.currentPage = .search
        } else {
            let selectedRecipe = RecipeDataModel.all[indexPath.row]
            vc.recipe = selectedRecipe
            selectedRecipeObject = RecipeService.convertRecipeToRecipeObject(recipe: selectedRecipe)
        }
        vc.recipeObject = selectedRecipeObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentPage == .search {
            return RecipeService.shared.recipes!.count
        } else {
            return RecipeDataModel.all.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }
        
        if currentPage == .search {
            if let recipe = RecipeService.shared.recipes?[indexPath.row] {
                var detailString = ""
                for ingredient in recipe.ingredient {
                    detailString += ingredient.key + " "
                }
                
                let imageURL = recipe.image
                let url = URL(string: imageURL)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)!
                
                cell.configure(withImage: image, title: recipe.name, detail: detailString, time: "\(recipe.time / 60) min", likes: "2.5k")
            }
            return cell
        } else {
            var image: UIImage = UIImage(named: "12218_large")!
            let recipe = RecipeDataModel.all[indexPath.row]
            if let imageURL = recipe.image {
                if let url = URL(string: imageURL) {
                    if let data = try? Data(contentsOf: url) {
                        if let imageFinal = UIImage(data: data) {
                            image = imageFinal
                        }
                    }
                }
            }
            let name = recipe.name ?? ""
            let detail = recipe.name ?? ""
            cell.configure(withImage: image, title: name, detail: detail, time: "\(recipe.time / 60) min", likes: "2.5k")
            return cell
        }
    }
    
    /// Header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All recipes"
    }
    
}
