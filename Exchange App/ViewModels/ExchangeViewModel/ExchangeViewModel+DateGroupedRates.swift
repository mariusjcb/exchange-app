//
//  ExchangeViewModel+DateGroupedRates.swift
//  Exchange App
//
//  Created by Marius Ilie on 22/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ExchangeViewModel where T == RatesResponseType.DateGrouped {
    open var chartPoints: Driver<[Currency: [PointEntry]]> {
        content.map { data in
            var result = [Currency: [PointEntry]]()
            data?.rates.forEach { rates in
                let date = rates.key.stringValue
                for (key, value) in rates.value {
                    if !result.keys.contains(key) {
                        result[key] = [PointEntry]()
                    }
                    result[key]?.append(PointEntry(value: value, label: date))
                }
            }
            return result
        }
    }

    open var viewModels: Observable<[CurrencyCardViewModel]>? {
        chartPoints
            .asObservable()
            .map { array in
                array.map { item -> CurrencyCardViewModel in
                    let chartPoints = self.chartPoints.asObservable().map({ $0[item.key]! })
                    return CurrencyCardViewModel(currency: item.key, chartPoints: chartPoints, randomizeTrigger: self.randomizeTrigger)
                }
            }
    }
}
