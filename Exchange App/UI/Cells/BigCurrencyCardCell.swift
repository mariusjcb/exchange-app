//
//  BigCurrencyCardCell.swift
//  Exchange App
//
//  Created by Marius Ilie on 22/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit
import RxSwift

class BigCurrencyCardCell: UITableViewCell {
    private var disposeBag = DisposeBag()
    private var viewModel: CurrencyCardViewModel?

    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var randomizeButton: UIButton!
    @IBOutlet private weak var chartView: LineChart! {
        didSet {
            self.chartView.dataEntries = []
            self.chartView.isCurved = true
        }
    }
    @IBOutlet private weak var headerImageView: UIImageView! {
        didSet {
            headerImageView.image?.getColors { colors in
                self.headerView.addShadow(shadowColor: colors?.primary ?? .clear)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        headerView.setLayerFrame()
    }

    func config(viewModel: CurrencyCardViewModel) {
        guard viewModel.currency != self.viewModel?.currency else { return }
        disposeBag = DisposeBag()
        viewModel.content
            .drive(onNext: { model in
                self.currencyLabel.text = model?.currency.rawValue ?? ""
                self.chartView.dataEntries = model?.entries
            }).disposed(by: disposeBag)

        randomizeButton.rx.tap
            .bind(to: viewModel.randomizeTrigger)
            .disposed(by: disposeBag)
    }
}
