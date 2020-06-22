//
//  SplashViewController+Layout.swift
//  Exchange App
//
//  Created by Marius Ilie on 22/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit

extension SplashViewController {
    internal func showLoader() {
        view.insertSubview(firstTimeLoader, at: 0)

        firstTimeLoader.translatesAutoresizingMaskIntoConstraints = false
        firstTimeLoader.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        firstTimeLoader.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        firstTimeLoader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        firstTimeLoader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true

        self.firstTimeLoaderImageView?.startAnimating()
        firstTimeLoaderImageView?.alpha = 0
        UIView.animate(withDuration: 2.0, animations: {
            self.firstTimeLoaderImageView?.alpha = 1
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.performSegue(withIdentifier: "OpenFirstScreen", sender: self)
        }
    }

    //MARK: - Setup

    internal func setupFirstLoaderView() {
        firstTimeLoader.backgroundColor = .white
        firstTimeLoader.isUserInteractionEnabled = true


        let imageView = UIImageView(frame: .zero)
        imageView.animationImages = .framesWithPrefix("sprinLoading", multiply: [1: 50])
        imageView.animationRepeatCount = 1
        imageView.animationDuration = 2.4
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        self.firstTimeLoaderImageView = imageView
        firstTimeLoader.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: firstTimeLoader.topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: firstTimeLoader.bottomAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: firstTimeLoader.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: firstTimeLoader.trailingAnchor, constant: 0).isActive = true
    }
}
