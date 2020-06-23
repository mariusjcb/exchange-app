//
//  SupportedCurrency.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

/// An enum with all supported currencies. Is a CodingKey enum, safe to use with Api Modules
public enum Currency: String, StringRawRepresentable, Equatable, CaseIterable, CodingKey {
    case EUR, USD, JPY, BGN, CZK, DKK, GBP, HUF, PLN, RON, SEK, CHF, ISK, NOK, HRK, RUB, TRY, AUD, BRL, CAD, CNY, HKD, IDR, ILS, INR, KRW, MXN, MYR, NZD, PHP, SGD, THB, ZAR

    static var `default`: Currency {
        return .EUR
    }
}

