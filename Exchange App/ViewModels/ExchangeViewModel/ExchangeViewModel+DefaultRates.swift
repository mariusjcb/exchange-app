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

extension ExchangeViewModel where T == RatesResponseType.Default {
    open var chartPoints: Driver<[Currency: [PointEntry]]> {
        content.map { data in
            guard let data = data else { return [:] }
            let rates = data.rates.map { PointEntry(value: $0.value, label: $0.key.rawValue) }
                .sorted { $0.label.compare($1.label) == ComparisonResult.orderedAscending  }
            return [data.base: rates]
        }
    }

    open var viewModels: Observable<[CurrencyCardViewModel]>? {
        content.map { data -> [CurrencyCardViewModel] in
            guard let data = data else { return [] }
            let chartPoints = self.chartPoints.asObservable().map({ $0[data.base]! })
            var viewModels = data.rates.sorted { $0.key.rawValue.compare($1.key.rawValue) == ComparisonResult.orderedAscending  }
                .map { CurrencyCardViewModel(currency: $0.key, rate: $0.value, randomizeTrigger: self.randomizeTrigger) }
            viewModels.insert(CurrencyCardViewModel(currency: data.base, chartPoints: chartPoints, randomizeTrigger: self.randomizeTrigger), at: 0)
            return viewModels
        }.asObservable()
    }
}
