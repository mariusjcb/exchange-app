//
//  AppSettings.swift
//  Exchange App
//
//  Created by Marius Ilie on 23/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

public struct AppSettings: Codable, Equatable {
    public let defaultCurrency: Currency
    public let refreshRate: Int
    public let autorefreshHistory: Bool
    public let historyStartDate: Date
    public let historyEndDate: Date?
    public let selectedHistorySymbols: [Currency]

    public init(_ currency: Currency, _ rate: Int, _ autorefreshHistory: Bool, _ startDate: Date, _ endDate: Date?, _ symbols: [Currency]) {
        self.defaultCurrency = currency
        self.refreshRate = rate
        self.autorefreshHistory = autorefreshHistory
        self.historyStartDate = startDate
        self.historyEndDate = endDate
        self.selectedHistorySymbols = symbols
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.defaultCurrency == rhs.defaultCurrency
            && lhs.refreshRate == rhs.refreshRate
            && lhs.autorefreshHistory == rhs.autorefreshHistory
            && lhs.historyStartDate == rhs.historyStartDate
            && lhs.historyEndDate == rhs.historyEndDate
            && lhs.selectedHistorySymbols.elementsEqual(rhs.selectedHistorySymbols)
    }
}
