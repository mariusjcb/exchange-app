//
//  ViewController+Layout.swift
//  Exchange App
//
//  Created by Marius Ilie on 22/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension ViewController {
    internal func setupViewModel() {
        disposeBag = DisposeBag()

        setupTitle()
        setupTableView()
        setupLoader()
        setupLastUpdateBinding()
    }

    internal func setupLoader() {
        viewModel.loading.drive(onNext: { isLoading in
            isLoading ? nil : self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
    }

    internal func setupTableView() {
        viewModel
            .viewModels
            .asObservable()
            .bind(to: tableView.rx.items) { (tableView, row, viewModel) -> UITableViewCell in
                if viewModel.isSmallCard {
                    let cell = tableView.dequeueReusableCell(withIdentifier: RateCardCell.identifier,
                                                             for: IndexPath.init(row: row, section: 0)) as! RateCardCell
                    cell.config(viewModel: viewModel)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: BigCurrencyCardCell.identifier,
                                                             for: IndexPath.init(row: row, section: 0)) as! BigCurrencyCardCell
                    cell.config(viewModel: viewModel)
                    return cell
                }
            }.disposed(by: disposeBag)

        Observable
            .combineLatest(viewModel!.loading.asObservable(),
                           viewModel.viewModels.asObservable().map { $0.isEmpty })
            .map { !$0 && $1 ? 1 : 0 }
            .bind(to: notFoundView.rx.alpha)
            .disposed(by: disposeBag)

        viewModel
            .isStarted
            .drive(onNext: { isStarted in
                UIApplication.shared.setLoader(!isStarted)
            }).disposed(by: disposeBag)
    }

    private func setupLastUpdateBinding() {
        viewModel.lastUpdate
            .asObservable()
            .bind(to: lastUpdateLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupTitle() {
        viewModel.title.asObservable()
            .subscribe(onNext: { self.title = $0 })
            .disposed(by: disposeBag)
    }
}
