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
    override func setupInputBinding(for source: BehaviorRelay<AppSettings>) {
        super.setupInputBinding(for: source)

        content.asObservable()
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .map { $0 != nil ? (self.getChartPoints(from: $0!), $0) : nil }
            .map { $0 != nil ? ($0!.0, self.getChildViewModels(from: $0!.1!, points: $0!.0)) : (nil, nil) }
            .subscribe(onNext: { (points, viewModels) in
                self.chartPointsStream.accept(points ?? [:])
                self.viewModelsStream.accept(viewModels ?? [])
            }).disposed(by: disposeBag)
    }
    
    public func getChartPoints(from data: RatesResponse<RatesResponseType.Default>) -> [Currency: [PointEntry]] {
        let rates = data.rates
            .map { PointEntry(value: $0.value, label: $0.key.rawValue) }
            .sorted { $0.label < $1.label }
        return [data.base: rates]
    }

    public func getChildViewModels(from data: RatesResponse<RatesResponseType.Default>, points: [Currency: [PointEntry]]) -> [CurrencyCardViewModel] {
        let chartPoints = self.chartPointsStream.asObservable().map({ $0[data.base] ?? [] })
        var viewModels = data.rates.sorted { $0.key.rawValue < $1.key.rawValue }
            .map { CurrencyCardViewModel(currency: $0.key, rate: $0.value, randomizeTrigger: self.randomizeTrigger) }
        viewModels.insert(CurrencyCardViewModel(currency: data.base, chartPoints: chartPoints, randomizeTrigger: self.randomizeTrigger), at: 0)
        return viewModels
    }
}
