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

public enum ExchangeViewModelAction: CaseIterable {
    case fetch
}

public protocol ExchangeViewModelProtocol: LoadableViewModel {
    var title: Driver<String?> { get }
    var lastUpdate: Driver<String?> { get }
    var randomizeTrigger: PublishSubject<Void> { get }
    var refreshInterval: BehaviorRelay<Int> { get }
    var selectedCurrency: BehaviorRelay<Currency> { get }
    var selectedSymbols: BehaviorRelay<[Currency]?> { get }
    var timeInterval: BehaviorRelay<(start: Date, end: Date)?> { get }
    var pausedRefreshing: BehaviorRelay<Bool> { get }

    func getChartPoints() -> Driver<[Currency: [PointEntry]]>
    func getChildViewModels() -> Observable<[CurrencyCardViewModel]>
}

open class ExchangeViewModel<T: Codable>: ViewModel, ExchangeViewModelProtocol {
    public typealias Model = RatesResponse<T>
    public typealias ActionType = ExchangeViewModelAction

    internal var disposeBag = DisposeBag()
    private let exchangeRatesApi: ExchangeRatesApi

    // MARK: - Private Streams

    private let loadingStream = BehaviorRelay<Bool>(value: true)
    private let contentStream = BehaviorRelay<Model?>(value: nil)
    private let errorStream = BehaviorRelay<Error?>(value: nil)
    private let lastUpdateStream = BehaviorRelay<Date?>(value: nil)

    // MARK: - Public Streams

    public let randomizeTrigger = PublishSubject<Void>()
    public let refreshInterval = BehaviorRelay<Int>(value: AppDefaults.DefaultRefreshRate)
    public let selectedCurrency = BehaviorRelay<Currency>(value: .default)
    public let selectedSymbols = BehaviorRelay<[Currency]?>(value: nil)
    public let timeInterval = BehaviorRelay<(start: Date, end: Date)?>(value: nil)
    public let pausedRefreshing = BehaviorRelay<Bool>(value: false)

    public var title: Driver<String?> {
        contentStream
            .flatMap { _ in self.selectedCurrency }
            .map { self.timeInterval.value == nil ? "Current Rate" : "History for \($0.rawValue)" }
            .asDriver(onErrorJustReturn: "")
    }

    public func getChartPoints() -> Driver<[Currency: [PointEntry]]> { .from([]) }
    public func getChildViewModels() -> Observable<[CurrencyCardViewModel]> { .from([]) }

    // MARK: - ViewModel Drivers & Lifecycle

    open var loading: Driver<Bool> { loadingStream.asDriver() }
    open var content: Driver<Model?> { contentStream.asDriver() }
    open var error: Driver<Error?> { errorStream.asDriver() }
    open var lastUpdate: Driver<String?> {
        lastUpdateStream
            .map { _ in "Last Update at: " + Date().convert(to: .hoursMinutes) }
            .asDriver(onErrorJustReturn: "NaN")
    }

    init(refreshTrigger: Observable<Void>, exchangeRatesApi: ExchangeRatesApi, source: BehaviorRelay<AppSettings>) {
        self.exchangeRatesApi = exchangeRatesApi

        setupOutputBinding(refreshOn: [refreshTrigger,
                                 selectedCurrency.asVoid(),
                                 selectedSymbols.asVoid(skip: 1),
                                 timeInterval.asVoid(skip: 1)])
        setupInputBinding(for: source)
    }

    // MARK: - Setup Binding

    internal func setupInputBinding(for source: BehaviorRelay<AppSettings>) {
        source.map { $0.refreshRate }.bind(to: refreshInterval).disposed(by: disposeBag)
        source.map { $0.defaultCurrency }.bind(to: selectedCurrency).disposed(by: disposeBag)
        source.map { $0.refreshRate }.bind(to: refreshInterval).disposed(by: disposeBag)
    }

    private func setupOutputBinding(refreshOn sources: [Observable<Void>]) {
        refreshInterval
            .flatMap { interval -> Observable<Void> in
                let timerObservable = Observable<Int>
                    .interval(.seconds(interval - AppDefaults.MIN_THROTTLE_INTERVAL), scheduler: MainScheduler.instance)
                    .filter { _ in !self.pausedRefreshing.value }
                    .takeUntil(self.refreshInterval.skip(1)).asVoid()
                return Observable.merge(sources + [timerObservable])
                    .throttle(.seconds(AppDefaults.MIN_THROTTLE_INTERVAL), latest: false, scheduler: MainScheduler.instance)
        }.subscribe(onNext: { _ in self.dispatch(.fetch) })
        .disposed(by: disposeBag)

        randomizeTrigger
            .map { _ in AppDefaults.SupportedCurrencies.randomElement()! }
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
        Observable.combineLatest(self.selectedCurrency, self.selectedSymbols, self.timeInterval)
            .flatMap { (currency, symbols, timeInterval) in
                self.exchangeRatesApi
                    .requestRates(currency: currency, symbols: symbols ?? [], from: timeInterval?.0, until: timeInterval?.1)
        }.subscribe(onNext: { self.accept(model: $0) },
                    onError: { self.reject(error: $0) })
        .disposed(by: disposeBag)
    }
}
