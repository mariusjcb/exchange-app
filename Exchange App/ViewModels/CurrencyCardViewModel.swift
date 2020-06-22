//
//  CurrencyCardViewModel.swift
//  Exchange App
//
//  Created by Marius Ilie on 22/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

open class CurrencyCardViewModel: ViewModel {
    public typealias Model = (currency: Currency, entries: [PointEntry], rate: Double?)
    private var disposeBag = DisposeBag()

    // MARK: - Streams

    private let contentStream = BehaviorRelay<Model?>(value: nil)
    public let randomizeTrigger: PublishSubject<Void>
    
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
    }
}
