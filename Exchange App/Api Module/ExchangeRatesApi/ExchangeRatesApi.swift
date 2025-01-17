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

/// Use it to interogate Rates Api
open class ExchangeRatesApi: BaseApi {
    let dateFormat = DateFormatter.Formats.dateOnly

    open override var encoder: JSONEncoder { .withDateFormat(dateFormat) }
    open override var decoder: JSONDecoder { .withDateFormat(dateFormat) }

    enum Paths: String {
        case latest = "/latest"
        case historical = "/history"
    }

    // MARK: - Requests

    /// A generic method used for all endpoints. *T should be a RatesResponseType member.*
    /** Use it only with supported types.
        * T should be a RatesResponseType member.*
        * This will rise an error if T is not a supported RateType
     */
    open func requestRates<T>(currency: Currency,
                              symbols: [Currency] = [],
                              from date: Date? = nil,
                              until endDate: Date? = nil) -> Observable<RatesResponse<T>> {
        guard RatesResponseType.isValidExchangeRateType(T.self) else {
            return .error(ApiError.unsupportedType)
        }
        
        let params = RatesParam(base: currency,
                                symbols: symbols,
                                from: date,
                                until: endDate)
        return request(.get, Paths.for(params, dateFormat: dateFormat), params: params)
    }
}
