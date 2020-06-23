//
//  SettingsViewModel.swift
//  Exchange App
//
//  Created by Marius Ilie on 23/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

open class AppSettingsViewModel: ViewModel {
    public typealias Model = Int
    private var disposeBag = DisposeBag()

    // MARK: - Streams

    private let contentStream = BehaviorRelay<Int>(value: AppDefaults.DefaultCurrencyIndex)

    public var content: Driver<Int?> { selectedCurrencyIndex.map { $0 < 0 ? nil : $0 }.asDriver(onErrorJustReturn: 0) }
    public let timeIntervalHistoryPageSelected = BehaviorRelay<Int>(value: 0)
    public let selectedCurrencyIndex: BehaviorRelay<Int>
    public let refreshTimeIntervalIndex: BehaviorRelay<Int>
    public let timeIntervalStartDate: BehaviorRelay<Date>
    public let timeIntervalEndDate: BehaviorRelay<Date?>
    public let autoRefreshHistory: BehaviorRelay<Bool>

    public var refreshTimeInterval: Driver<Int> {
        refreshTimeIntervalIndex.map {
            if $0 < AppDefaults.RefreshTimeIntervals.count {
                return AppDefaults.RefreshTimeIntervals[$0]
            } else {
                return AppDefaults.DefaultRefreshRate
            }
        }.asDriver(onErrorJustReturn: AppDefaults.DefaultRefreshRate)
    }

    public var currency: Driver<Currency> {
        selectedCurrencyIndex.map {
            if $0 < AppDefaults.SupportedCurrencies.count {
                return AppDefaults.SupportedCurrencies[$0]
            } else {
                return AppDefaults.DefaultCurrency
            }
        }.asDriver(onErrorJustReturn: AppDefaults.DefaultCurrency)
    }

    public var currencies: Driver<[Currency]> {
        Observable.from(AppDefaults.SupportedCurrencies).toArray().asDriver(onErrorJustReturn: [])
    }

    // MARK: - Setup

    init(initialValue: AppSettings) {
        let currencyIndex = AppDefaults.SupportedCurrencies.firstIndex(of: initialValue.defaultCurrency) ?? 0
        let refreshIntervalIndex = AppDefaults.RefreshTimeIntervals.firstIndex(of: initialValue.refreshRate) ?? 0

        self.selectedCurrencyIndex = .init(value: currencyIndex)
        self.refreshTimeIntervalIndex = .init(value: refreshIntervalIndex)
        self.autoRefreshHistory = .init(value: initialValue.autorefreshHistory)
        self.timeIntervalStartDate = .init(value: initialValue.historyStartDate)
        self.timeIntervalEndDate = .init(value: initialValue.historyEndDate)
    }

    convenience init(source: BehaviorRelay<AppSettings>) {
        self.init(initialValue: source.value)

        Observable
            .combineLatest(currency.asObservable(),
                           refreshTimeInterval.asObservable(),
                           autoRefreshHistory,
                           timeIntervalStartDate,
                           timeIntervalEndDate)
            .map { AppSettings($0, $1, $2, $3, $4, AppDefaults.HistorySelectedCurrencies) }
            .filter { source.value != $0 }
            .bind(to: source)
            .disposed(by: disposeBag)

        source
            .subscribe(onNext: { self.accept(appSettings: $0)})
            .disposed(by: disposeBag)
    }

    func accept(appSettings: AppSettings) {
        self.accept(AppDefaults.SupportedCurrencies.firstIndex(of: appSettings.defaultCurrency) ?? 0, in: self.selectedCurrencyIndex)
        self.accept(AppDefaults.RefreshTimeIntervals.firstIndex(of: appSettings.refreshRate) ?? 0, in: self.refreshTimeIntervalIndex)
        self.accept(appSettings.autorefreshHistory, in: self.autoRefreshHistory)
        self.accept(appSettings.historyStartDate, in: self.timeIntervalStartDate)
        self.accept(appSettings.historyEndDate, in: self.timeIntervalEndDate)
    }

    func accept<T: Equatable>(_ value: T, in relay: BehaviorRelay<T>) {
        guard value != relay.value else { return }
        relay.accept(value)
    }
}
