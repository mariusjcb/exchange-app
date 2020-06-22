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

class ViewController: BaseViewController, UITableViewDelegate {
    internal var disposeBag = DisposeBag()

    internal let refreshControl = UIRefreshControl()
    @IBOutlet internal weak var notFoundView: UIView!
    @IBOutlet internal weak var lastUpdateLabel: UILabel!
    @IBOutlet internal weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        }
    }

    init?(coder: NSCoder, title: String) {
        super.init(coder: coder)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Dependencies

    let refreshTrigger = PublishSubject<Void>()
    var viewModel: ExchangeViewModelProtocol! { didSet { isViewLoaded ? setupViewModel() : nil } }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.pausedRefreshing.accept(false)
        refreshTrigger.onNext(())
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.pausedRefreshing.accept(true)
    }

    // MARK: - Actions

    @IBAction @objc func refresh() {
        self.refreshTrigger.onNext(())
    }
}
