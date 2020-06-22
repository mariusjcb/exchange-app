//
//  ExchangeRatesService.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private let MIN_THROTTLE_INTERVAL = 3

public enum ExchangeListViewModelAction: CaseIterable {
    case fetch
}

open class ExchangeViewModel<T: Codable>: ViewModel {
    public typealias Model = RatesResponse<T>
    public typealias ActionType = ExchangeListViewModelAction

    private var disposeBag = DisposeBag()
    private let exchangeRatesApi: ExchangeRatesApi

    // MARK: - Private Streams

    private let loadingStream = BehaviorRelay<Bool>(value: false)
    private let contentStream = BehaviorRelay<Model?>(value: nil)
    private let errorStream = BehaviorRelay<Error?>(value: nil)
    private let lastUpdateStream = BehaviorRelay<Date?>(value: nil)

    // MARK: - Public Streams

    public let refreshInterval = BehaviorRelay<Int>(value: 3)
    public let selectedCurrency = BehaviorRelay<Currency>(value: .default)
    public let selectedSymbols = BehaviorRelay<[Currency]?>(value: nil)
    public let timeInterval = BehaviorRelay<(start: Date, end: Date)?>(value: nil)

    // MARK: - ViewModel Drivers & Lifecycle

    open var loading: Driver<Bool> { loadingStream.asDriver() }
    open var content: Driver<Model?> { contentStream.asDriver() }
    open var error: Driver<Error?> { errorStream.asDriver() }
    open var lastUpdate: Driver<Date?> { lastUpdateStream.asDriver() }

    init(uiTriggers: (refreshTrigger: Observable<Void>, randomizeTrigger: Observable<Void>),
         exchangeRatesApi: ExchangeRatesApi) {
        self.exchangeRatesApi = exchangeRatesApi

        setupBinding(refreshOn: [uiTriggers.refreshTrigger,
                                 selectedCurrency.asVoid(),
                                 selectedSymbols.asVoid(skip: 1),
                                 timeInterval.asVoid(skip: 1)])
    }

    // MARK: - Setup Binding

    private func setupBinding(refreshOn sources: [Observable<Void>]) {
        refreshInterval
            .flatMap { interval -> Observable<Void> in
                let timerObservable = Observable<Int>
                    .interval(.seconds(interval - 3), scheduler: MainScheduler.instance)
                    .takeUntil(self.refreshInterval.skip(1)).asVoid()
                return Observable.merge(sources + [timerObservable])
                    .throttle(.seconds(MIN_THROTTLE_INTERVAL), latest: false, scheduler: MainScheduler.instance)
        }.subscribe(onNext: { _ in self.dispatch(.fetch) })
            .disposed(by: disposeBag)
    }

    // MARK: - ViewModel Protocol

    open func dispatch(_ action: ActionType) {
        switch action {
        case .fetch: loadNewData()
        }
    }

    public func accept(model: RatesResponse<T>) {
        self.loadingStream.accept(false)
        self.contentStream.accept(model)
        self.errorStream.accept(nil)
        self.lastUpdateStream.accept(Date())
    }

    public func reject(error: Error) {
        self.loadingStream.accept(false)
        self.contentStream.accept(nil)
        self.errorStream.accept(error)
        self.lastUpdateStream.accept(Date())
    }

    // MARK: - Actions

    private func loadNewData() {
        self.loadingStream.accept(true)
        Observable.zip(self.selectedCurrency, self.selectedSymbols, self.timeInterval)
            .flatMap { (currency, symbols, timeInterval) in
                self.exchangeRatesApi
                    .requestRates(currency: currency, symbols: symbols ?? [], from: timeInterval?.0, until: timeInterval?.1)
        }.subscribe(onNext: { self.accept(model: $0) },
                    onError: { self.reject(error: $0) })
        .disposed(by: disposeBag)
    }
}

extension ExchangeViewModel where T == RatesResponseType.Default {
    open var chartPoints: Driver<[Currency: [PointEntry]]> {
        content.map { data in
            guard let data = data else { return [:] }
            let rates = data.rates.map { PointEntry(value: $0.value, label: $0.key.rawValue) }
            return [data.base: rates]
        }
    }
}

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
}
