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
    var imagePrefix: String? {
        didSet {
            setupAnimation()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAnimation()
    }

    private func setupAnimation() {
        self.animationImages = .framesWithPrefix(imagePrefix ?? "", multiply: [])
        self.animationDuration = 1.0
        startAnimating()
    }
}
