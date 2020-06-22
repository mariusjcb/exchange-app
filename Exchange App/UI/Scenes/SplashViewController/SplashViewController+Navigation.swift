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
        let api = ExchangeRatesApi(requestAdapter: BaseRequestAdapter(host: "https://api.exchangeratesapi.io/"))
        guard let viewController = ViewController(coder: coder, title: "Current rate") else { return nil }
        let viewModel = DefaultExchangeViewModel(refreshTrigger: viewController.refreshTrigger,
                                                 exchangeRatesApi: api)
        viewModel.refreshInterval.accept(3)
        viewController.viewModel = viewModel
        return viewController
    }

    @IBSegueAction
    func makeHistoryScreen(coder: NSCoder) -> ViewController? {
        let api = ExchangeRatesApi(requestAdapter: BaseRequestAdapter(host: "https://api.exchangeratesapi.io/"))
        guard let viewController = ViewController(coder: coder, title: "History") else { return nil }
        let viewModel = DateGroupedExchangeViewModel(refreshTrigger: viewController.refreshTrigger,
                                                 exchangeRatesApi: api)
        let date = Date().addingTimeInterval(-10 * 24 * 60 * 60)
        viewModel.selectedSymbols.accept([.RON, .BGN, .USD])
        viewModel.timeInterval.accept((start: date, end: Date()))
        viewModel.refreshInterval.accept(10)
        viewController.viewModel = viewModel
        return viewController
    }
}
