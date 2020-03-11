//
//  GradientView.swift
//  Reciplease
//
//  Created by Edouard PLANTEVIN on 29/01/2020.
//  Copyright © 2020 Edouard PLANTEVIN. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as? CAGradientLayer
        gradientLayer?.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.cgColor]
    }
}
