//
//  AppDefaults.swift
//  Exchange App
//
//  Created by Marius Ilie on 23/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

/// Here are stored most of default values from this app
/*
    You can use those values anywhere.
    Do not store sensitive data there.
 */
public struct AppDefaults {
    public static let DefaultRefreshRate: Int = 3
    public static let RefreshTimeIntervals: [Int] = [3, 5, 15]

    public static var DefaultCurrency: Currency { .EUR }
    public static var DefaultCurrencyIndex: Int { SupportedCurrencies.firstIndex(of: DefaultCurrency)! }
    public static var SupportedCurrencies: [Currency] { Currency.allCases }

    public static let HistorySelectedCurrencies: [Currency] = [.RON, .USD, .BGN]

    /// 10 days ago
    public static var DefaultStartDate: Date { Date().addingTimeInterval(-10 * 24 * 60 * 60) }

    public static let DefaultFlag = "flag-placeholder"
    public static let DefaultFlagBG = "EUR_BG"

    public static let MIN_THROTTLE_INTERVAL = DefaultRefreshRate

    public static var DefaultAppSettings: AppSettings {
        AppSettings(DefaultCurrency, DefaultRefreshRate, true, DefaultStartDate, nil, AppDefaults.HistorySelectedCurrencies)
    }
}
