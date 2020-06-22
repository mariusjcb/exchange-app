//
//  WelcomeViewController.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit

final class SplashViewController: BaseViewController {
    public internal(set) var firstTimeLoaderImageView: UIImageView?
    public internal(set) var firstTimeLoader: UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoaderView()
        showLoader()
    }
}
