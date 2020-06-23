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

    override func setupInputBinding(for source: BehaviorRelay<AppSettings>) {
        super.setupInputBinding(for: source)

        content.asObservable()
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .map { $0 != nil ? self.getChartPoints(from: $0!) : nil }
            .map { $0 != nil ? ($0, self.getChildViewModels(from: $0!)) : (nil, nil) }
            .subscribe(onNext: { (points, viewModels) in
                self.chartPointsStream.accept(points ?? [:])
                self.viewModelsStream.accept(viewModels ?? [])
            }).disposed(by: disposeBag)

        source.subscribe(onNext: { appSetings in
            self.selectedSymbols.accept(appSetings.selectedHistorySymbols)
            self.timeInterval.accept((start: appSetings.historyStartDate,
                                      end: appSetings.historyEndDate ?? Date()))
        }).disposed(by: disposeBag)

        source.map { $0.autorefreshHistory }
            .map { self.timeInterval.value?.start != nil && !$0 }
            .subscribe(onNext: { self.pausedRefreshing.accept($0) })
            .disposed(by: disposeBag)
    }

    public func getChartPoints(from data: RatesResponse<RatesResponseType.DateGrouped>) -> [Currency: [PointEntry]] {
        var result = [Currency: [PointEntry]]()
        data.rates.forEach { rates in
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

    public func getChildViewModels(from array: [Currency: [PointEntry]]) -> [CurrencyCardViewModel] {
        array.map { item -> CurrencyCardViewModel in
            let chartPoints = self.chartPointsStream.asObservable().map({ $0[item.key] ?? [] })
            return CurrencyCardViewModel(currency: item.key, chartPoints: chartPoints, randomizeTrigger: self.randomizeTrigger)
        }.sorted { $0.currency!.rawValue < $1.currency!.rawValue }
    }
}
