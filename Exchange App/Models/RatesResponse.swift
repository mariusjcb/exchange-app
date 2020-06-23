//
//  RatesResponse.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

public struct RatesResponse<T: Codable & Equatable>: Codable, Equatable {
    public let rates: T
    public let base: Currency
    public let date: Date?
    public let firstDate: Date?
    public let lastDate: Date?

    public enum CodingKeys: String, CodingKey {
        case rates, base, date
        case firstDate = "start_at"
        case lastDate = "end_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RatesResponse.CodingKeys.self)
        self.base = try container.decode(Currency.self, forKey: .base)
        self.date = try? container.decode(Date.self, forKey: .base)
        self.firstDate = try? container.decode(Date.self, forKey: .base)
        self.lastDate = try? container.decode(Date.self, forKey: .base)
        self.rates = try RatesResponseType.decode(T.self, from: container, forKey: .rates)!
    }

    public static func == (lhs: RatesResponse<T>, rhs: RatesResponse<T>) -> Bool {
        return lhs.rates == rhs.rates
            && lhs.base == rhs.base
            && lhs.date == rhs.date
            && lhs.firstDate == rhs.firstDate
            && lhs.lastDate == rhs.lastDate
    }
}
