//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 10/02/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageRecipe: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(withImage image: UIImage, title: String, detail: String, time: String, likes: String) {
        titleLabel.text = title
        detailLabel.text = detail
        timeLabel.text = time
        likesLabel.text = likes
        imageRecipe.image = image
    }
    
}
