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

public enum ExchangeViewModelAction: CaseIterable {
    case fetch
}

open class ExchangeViewModel<T: Codable>: ViewModel, ActionableViewModel {
    public typealias Model = RatesResponse<T>
    public typealias ActionType = ExchangeViewModelAction

    private var disposeBag = DisposeBag()
    private let exchangeRatesApi: ExchangeRatesApi

    // MARK: - Private Streams

    private let loadingStream = BehaviorRelay<Bool>(value: false)
    private let contentStream = BehaviorRelay<Model?>(value: nil)
    private let errorStream = BehaviorRelay<Error?>(value: nil)
    private let lastUpdateStream = BehaviorRelay<Date?>(value: nil)

    // MARK: - Public Streams

    public let randomizeTrigger = PublishSubject<Void>()
    public let refreshInterval = BehaviorRelay<Int>(value: 3)
    public let selectedCurrency = BehaviorRelay<Currency>(value: .default)
    public let selectedSymbols = BehaviorRelay<[Currency]?>(value: nil)
    public let timeInterval = BehaviorRelay<(start: Date, end: Date)?>(value: nil)

    open var chartPoints: Driver<[Currency: [PointEntry]]>?
    open var viewModels: Observable<[CurrencyCardViewModel]>?

    // MARK: - ViewModel Drivers & Lifecycle

    open var loading: Driver<Bool> { loadingStream.asDriver() }
    open var content: Driver<Model?> { contentStream.asDriver() }
    open var error: Driver<Error?> { errorStream.asDriver() }
    open var lastUpdate: Driver<String?> {
        lastUpdateStream
            .map { _ in "Last Update at: " + Date().convert(to: .hoursMinutes) }
            .asDriver(onErrorJustReturn: "NaN")
    }

    init(refreshTrigger: Observable<Void>, exchangeRatesApi: ExchangeRatesApi) {
        self.exchangeRatesApi = exchangeRatesApi

        setupBinding(refreshOn: [refreshTrigger,
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

        randomizeTrigger
            .map { _ in Currency.allCases.randomElement()! }
            .bind(to: selectedCurrency)
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
