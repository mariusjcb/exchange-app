//
//  ViewController+Navigation.swift
//  Exchange App
//
//  Created by Marius Ilie on 23/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit

extension ViewController {
    @IBSegueAction
    func makeSettingsScreen(coder: NSCoder) -> SettingsViewController? {
        let viewModel = AppSettingsViewModel(source: UIApplication.shared.settingsSource)
        return SettingsViewController(coder: coder, viewModel: viewModel)
    }
}
