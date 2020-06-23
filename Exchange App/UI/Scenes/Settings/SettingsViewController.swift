//
//  SettingsViewController.swift
//  Exchange App
//
//  Created by Marius Ilie on 23/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UITableViewController {
    internal var disposeBag = DisposeBag()
    var viewModel: AppSettingsViewModel! { didSet { isViewLoaded ? setupViewModel() : nil } }

    @IBOutlet internal weak var refreshRateControl: UISegmentedControl!
    @IBOutlet internal weak var selectedCurrencyLabel: UILabel!
    @IBOutlet internal weak var countryPickerView: UIPickerView!
    @IBOutlet internal weak var autorefreshHistory: UISwitch!
    @IBOutlet internal weak var timeIntervalPageControl: UISegmentedControl!
    @IBOutlet internal weak var datePicker: UIDatePicker!

    required init?(coder: NSCoder) { fatalError() }
    init?(coder: NSCoder, viewModel: AppSettingsViewModel?) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }

    // MARK: - Setup

    internal func setupViewModel() {
        setupInputBinders()
        setupOutputBinders()
    }

    @IBAction func dismiss() {
        self.dismiss(animated: true)
    }
}
