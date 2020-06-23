//
//  SplashViewController+Navigation.swift
//  Exchange App
//
//  Created by Marius Ilie on 22/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit

extension SplashViewController {
    @IBSegueAction
    func makeHomeScreen(coder: NSCoder) -> ViewController? {
        guard let viewController = ViewController(coder: coder, title: "Current rate") else { return nil }
        let exchangeApi = ExchangeRatesApi(requestAdapter: UIApplication.shared.exchangeApiRequestsAdapter)

        let viewModel = DefaultExchangeViewModel(refreshTrigger: viewController.refreshTrigger,
                                                 exchangeRatesApi: exchangeApi,
                                                 source: UIApplication.shared.settingsSource)
        viewController.viewModel = viewModel

        return viewController
    }

    @IBSegueAction
    func makeHistoryScreen(coder: NSCoder) -> ViewController? {
        guard let viewController = ViewController(coder: coder, title: "History") else { return nil }
        let exchangeApi = ExchangeRatesApi(requestAdapter: UIApplication.shared.exchangeApiRequestsAdapter)

        let viewModel = DateGroupedExchangeViewModel(refreshTrigger: viewController.refreshTrigger,
                                                     exchangeRatesApi: exchangeApi,
                                                     source: UIApplication.shared.settingsSource)
        viewController.viewModel = viewModel

        return viewController
    }
}
