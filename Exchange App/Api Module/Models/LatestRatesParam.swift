//
//  LatestRatesParam.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

struct RatesParam<Model: StringRawRepresentable>: RequestParamRepresentable, Codable {
    let base: String?
    let symbols: String?

    init(base: Model, symbols: [Model]) {
        self.base = base.rawValue.uppercased()
        self.symbols = symbols.map(\.rawValue).joined(separator: ",").uppercased()
    }

    init(from model: Model) {
        self.base = model.rawValue.uppercased()
        self.symbols = nil
    }
}
