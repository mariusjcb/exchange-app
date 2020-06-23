//
//  ExchangeApiRequestAdapter.swift
//  Exchange App
//
//  Created by Marius Ilie on 23/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

class ExchangeApiRequestAdapter: BaseRequestAdapter {
    var environment: Environment
    enum Environment: String {
        case prod = "https://api.exchangeratesapi.io/"
        case dev = ""
    }

    var host: String { environment.rawValue }

    init(env: Environment) {
        self.environment = env
        super.init(host: env.rawValue)
    }
}
