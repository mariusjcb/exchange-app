//
//  SettingsViewController+Navigation.swift
//  Exchange App
//
//  Created by Marius Ilie on 23/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension SettingsViewController {
    internal func setupInputBinders() {
        disposeBag = DisposeBag()

        viewModel
            .refreshTimeIntervalIndex
            .bind(to: refreshRateControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)

        viewModel.currencies
            .asObservable()
            .bind(to: countryPickerView.rx.itemTitles) { row, element in element.rawValue }
            .disposed(by: disposeBag)

        viewModel.selectedCurrencyIndex
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { self.countryPickerView.selectRow($0, inComponent: 0, animated: true) })
            .disposed(by: disposeBag)

        viewModel.autoRefreshHistory
            .bind(to: autorefreshHistory.rx.isOn)
            .disposed(by: disposeBag)

        viewModel.currency
            .map { $0.rawValue }
            .asObservable()
            .bind(to: selectedCurrencyLabel.rx.text)
            .disposed(by: disposeBag)

        Observable.combineLatest(viewModel.timeIntervalStartDate,
                                 viewModel.timeIntervalEndDate,
                                 viewModel.timeIntervalHistoryPageSelected)
            .map { $0.2 == 0 ? $0.0 : $0.1 ?? Date() }
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: datePicker.rx.date)
            .disposed(by: disposeBag)
    }

    internal  func setupOutputBinders() {
        datePicker.rx.date.skip(1)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { date in
                if self.timeIntervalPageControl.selectedSegmentIndex == 0 {
                    self.viewModel.timeIntervalStartDate.accept(date)
                } else {
                    self.viewModel.timeIntervalEndDate.accept(date)
                }
            }).disposed(by: disposeBag)

        refreshRateControl.rx
            .selectedSegmentIndex
            .bind(to: viewModel.refreshTimeIntervalIndex)
            .disposed(by: disposeBag)

        countryPickerView.rx
            .itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectedCurrencyIndex)
            .disposed(by: disposeBag)

        timeIntervalPageControl.rx
            .selectedSegmentIndex
            .bind(to: viewModel.timeIntervalHistoryPageSelected)
            .disposed(by: disposeBag)

        autorefreshHistory.rx.isOn
            .bind(to: viewModel.autoRefreshHistory)
            .disposed(by: disposeBag)
    }
}
