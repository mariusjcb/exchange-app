//
//  ViewController.swift
//  Exchange App
//
//  Created by Marius Ilie on 20/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit
import RxSwift
import UIImageColors
import RxDataSources

class ViewController<T: Codable>: BaseViewController, UITableViewDelegate {
    let disposeBag = DisposeBag()

    private enum CellId: String {
        case bigCardCell = "BigCardCellId"
        case rateCardCell = "RateCardCellId"
    }

    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        }
    }

    // MARK: - Dependencies

    lazy var refreshTrigger = PublishSubject<Void>()

    lazy var exchangeRatesApi = ExchangeRatesApi(requestAdapter: BaseRequestAdapter(host: "https://api.exchangeratesapi.io/"))
    lazy var viewModel: ExchangeViewModel<T> = ExchangeViewModel<T>(refreshTrigger: refreshTrigger, exchangeRatesApi: exchangeRatesApi)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLoader()
        setupLastUpdateBinding()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTrigger.onNext(())
    }

    // MARK: - Setup

    private func setupLoader() {
        viewModel.loading.drive(onNext: { isLoading in
            isLoading ? nil : self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
    }

    private func setupTableView() {
        viewModel.viewModels?
            .bind(to: tableView.rx.items) { (tableView, row, viewModel) -> UITableViewCell in
                if viewModel.isSmallCard {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CellId.rateCardCell.rawValue,
                                                             for: IndexPath.init(row: row, section: 0)) as! RateCardCell
                    cell.config(viewModel: viewModel)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CellId.bigCardCell.rawValue,
                                                             for: IndexPath.init(row: row, section: 0)) as! BigCurrencyCardCell
                    cell.config(viewModel: viewModel)
                    return cell
                }
            }.disposed(by: disposeBag)
    }

    private func setupLastUpdateBinding() {
        viewModel.lastUpdate
            .asObservable()
            .bind(to: lastUpdateLabel.rx.text)
            .disposed(by: disposeBag)
    }

    // MARK: - Actions

    @objc func refresh() {
        self.refreshTrigger.onNext(())
    }
}
