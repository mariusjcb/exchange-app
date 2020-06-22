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

class DateGroupedExchangeViewModel: ExchangeViewModel<RatesResponseType.DateGrouped> {
    private var dateFormat: DateFormatter.Formats = .dateOnly

    public override func getChartPoints() -> Driver<[Currency: [PointEntry]]> {
        content.map { data in
            var result = [Currency: [PointEntry]]()
            data?.rates.forEach { rates in
                let date = rates.key.convert(to: self.dateFormat)
                for (key, value) in rates.value {
                    if !result.keys.contains(key) {
                        result[key] = [PointEntry]()
                    }
                    let point = PointEntry(value: value, label: date)
                    let index = result[key]!.insertionIndexOf(point) { el1, el2 in
                        if let date1 = el1.label.convert(to: self.dateFormat),
                            let date2 = el2.label.convert(to: self.dateFormat) {
                            return date1.compare(date2) == .orderedAscending
                        } else {
                            return el1.label < el2.label
                        }
                    }
                    result[key]!.insert(point, at: index)
                }
            }
            return result
        }
    }

    public override func getChildViewModels() -> Observable<[CurrencyCardViewModel]> {
        getChartPoints()
            .asObservable()
            .map { array in
                array.map { item -> CurrencyCardViewModel in
                    let chartPoints = self.getChartPoints().asObservable().map({ $0[item.key]! })
                    return CurrencyCardViewModel(currency: item.key, chartPoints: chartPoints, randomizeTrigger: self.randomizeTrigger)
                }.sorted { $0.currency!.rawValue < $1.currency!.rawValue }
            }
    }
}
