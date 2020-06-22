//
//  ExchangeViewModel+DefaultRates.swift
//  Exchange App
//
//  Created by Marius Ilie on 22/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DefaultExchangeViewModel: ExchangeViewModel<RatesResponseType.Default> {
    public override func getChartPoints() -> Driver<[Currency: [PointEntry]]> {
        content.map { data in
            guard let data = data else { return [:] }
            let rates = data.rates.map { PointEntry(value: $0.value, label: $0.key.rawValue) }
                .sorted { $0.label < $1.label }
            return [data.base: rates]
        }
    }

    public override func getChildViewModels() -> Observable<[CurrencyCardViewModel]> {
        content.map { data -> [CurrencyCardViewModel] in
            guard let data = data else { return [] }
            let chartPoints = self.getChartPoints().asObservable().map({ $0[data.base]! })
            var viewModels = data.rates.sorted { $0.key.rawValue < $1.key.rawValue }
                .map { CurrencyCardViewModel(currency: $0.key, rate: $0.value, randomizeTrigger: self.randomizeTrigger) }
            viewModels.insert(CurrencyCardViewModel(currency: data.base, chartPoints: chartPoints, randomizeTrigger: self.randomizeTrigger), at: 0)
            return viewModels
        }.asObservable()
    }
}
