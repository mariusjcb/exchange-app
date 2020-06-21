//
//  ExchangeRatesApi.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class ExchangeRatesApi: BaseApi {

    func requestLatestRates() -> Observable<String> {
        request(.get, "/latest")
    }

    func requestRates(for date: Date) -> Observable<String> {
        request(.get, date.convert(to: .dateOnly))
    }

}
