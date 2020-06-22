//
//  CurrencyCardViewModel.swift
//  Exchange App
//
//  Created by Marius Ilie on 22/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class CurrencyCardViewModel: ViewModel {
    public typealias Model = (currency: Currency, entries: [PointEntry], rate: Double?)
    private var disposeBag = DisposeBag()

    private static var DefaultFlag = "flag-placeholder"
    private static var DefaultBG = "EUR_BG"

    // MARK: - Streams

    private let contentStream = BehaviorRelay<Model?>(value: nil)
    private let currencyImageStream = BehaviorRelay<UIImage>(value: UIImage(named: DefaultFlag)!)
    private let currencyBackgroundImageStream = BehaviorRelay<UIImage>(value: UIImage(named: DefaultBG)!)
    public let randomizeTrigger: PublishSubject<Void>

    public var currencyImage: Driver<UIImage> { currencyImageStream.asDriver() }
    public var currencyBackgroundImage: Driver<UIImage> { currencyBackgroundImageStream.asDriver() }
    
    open var content: Driver<Model?> { contentStream.asDriver() }
    var currency: Currency? { contentStream.value?.currency }
    var isSmallCard: Bool { contentStream.value?.rate != nil }

    init(currency: Currency, rate: Double? = nil, chartPoints: Observable<[PointEntry]>? = nil, randomizeTrigger: PublishSubject<Void>) {
        self.randomizeTrigger = randomizeTrigger
        contentStream.accept((currency, [], rate))

        chartPoints?
            .map { (currency, $0, rate) }
            .bind(to: contentStream)
            .disposed(by: disposeBag)

        contentStream
            .map { UIImage(named: $0?.currency.rawValue.lowercased() ?? CurrencyCardViewModel.DefaultFlag) }
            .map { $0 == nil ? UIImage(named: CurrencyCardViewModel.DefaultFlag)! : $0! }
            .bind(to: currencyImageStream)
            .disposed(by: disposeBag)

        contentStream
            .map { UIImage(named: ($0?.currency.rawValue.uppercased() ?? "") + "_BG") ?? UIImage(named: $0?.currency.rawValue.lowercased() ?? "") }
            .map { $0 == nil ? UIImage(named: CurrencyCardViewModel.DefaultBG)! : $0! }
            .bind(to: currencyBackgroundImageStream)
            .disposed(by: disposeBag)
    }
}
