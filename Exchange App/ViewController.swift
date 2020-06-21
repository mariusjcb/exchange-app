//
//  ViewController.swift
//  Exchange App
//
//  Created by Marius Ilie on 20/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    lazy var refreshTrigger = PublishSubject<Void>()
    lazy var selectTrigger = PublishSubject<Void>()

    lazy var exchangeRatesApi = ExchangeRatesApi(requestAdapter: BaseRequestAdapter(host: "https://api.exchangeratesapi.io/"))
    lazy var viewModel = ExchangeListViewModel<RatesResponseType.Default>(uiTriggers: (refreshTrigger: refreshTrigger, selectTrigger: selectTrigger),
                                                                          exchangeRatesApi: exchangeRatesApi)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.selectedCurrency.accept(.AUD)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTrigger.onNext(())
    }
}
