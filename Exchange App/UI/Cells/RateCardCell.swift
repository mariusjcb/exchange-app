//
//  RateCardCell.swift
//  Exchange App
//
//  Created by Marius Ilie on 22/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit
import RxSwift

open class RateCardCell: UITableViewCell {
    public static var identifier: String { return "RateCardCellId" }

    private var disposeBag = DisposeBag()
    private var viewModel: CurrencyCardViewModel?

    @IBOutlet private weak var currencyImageView: UIImageView!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!

    func config(viewModel: CurrencyCardViewModel) {
        guard viewModel.currency != self.viewModel?.currency else { return }
        disposeBag = DisposeBag()

        viewModel
            .currencyImage
            .asObservable()
            .bind(to: currencyImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.content
            .drive(onNext: { model in
                self.currencyLabel.text = model?.currency.rawValue ?? ""
                self.rateLabel.text = "\(model?.rate ?? 0)"
            }).disposed(by: disposeBag)
    }
}
