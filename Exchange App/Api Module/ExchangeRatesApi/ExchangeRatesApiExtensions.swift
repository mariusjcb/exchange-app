//
//  ExchangeRatesApiExtensions.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

extension ExchangeRatesApi.Paths {
    static func `for`(_ param: RatesParam<Currency>, dateFormat: DateFormatter.Formats = .default) -> String {
        if param.isHistorical {
            return ExchangeRatesApi.Paths.historical.rawValue
        } else {
            if let date = param.date {
                return date.convert(to: dateFormat)
            } else {
                return ExchangeRatesApi.Paths.latest.rawValue
            }
        }
    }
}
