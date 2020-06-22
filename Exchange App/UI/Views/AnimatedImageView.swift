//
//  NotFoundImageView.swift
//  Exchange App
//
//  Created by Marius Ilie on 22/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit

class AnimatedImageView: UIImageView {
    @IBInspectable
    var imagePrefix: String = "" {
        didSet {
            self.animationImages = .framesWithPrefix(imagePrefix, multiply: [:])
        }
    }

    @IBInspectable
    var duration: Double {
        get {
            return self.animationDuration
        }
        set {
            self.animationDuration = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.animationImages = .framesWithPrefix(imagePrefix, multiply: [:])
        startAnimating()
    }
}
