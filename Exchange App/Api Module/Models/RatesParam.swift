//
//  LatestRatesParam.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

struct RatesParam<Model: StringRawRepresentable>: RequestParamRepresentable, Codable {
    let base: String
    let symbols: String?
    let date: Date?
    let firstDate: Date?
    let lastDate: Date?

    init(base: Model, symbols: [Model] = [], from date: Date? = nil, until endDate: Date? = nil) {
        self.base = base.rawValue.uppercased()
        self.symbols = symbols.isEmpty ? nil : symbols.map(\.rawValue).joined(separator: ",").uppercased()
        self.date = endDate == nil ? date : nil
        self.firstDate = endDate != nil ? date : nil
        self.lastDate = endDate
    }

    init(from model: Model) {
        self.base = model.rawValue.uppercased()
        self.symbols = nil
        self.date = nil
        self.firstDate = nil
        self.lastDate = nil
    }

    enum CodingKeys: String, CodingKey {
        case base, symbols, date
        case firstDate = "start_at"
        case lastDate = "end_at"
    }
}

// MARK: - Helpers

extension RatesParam {
    var isHistorical: Bool {
        return firstDate != nil || lastDate != nil
    }
}
