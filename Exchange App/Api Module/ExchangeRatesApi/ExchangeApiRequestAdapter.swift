//
//  ExchangeApiRequestAdapter.swift
//  Exchange App
//
//  Created by Marius Ilie on 23/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

/// This will append ExchangeApi host to your paths in api module
class ExchangeApiRequestAdapter: BaseRequestAdapter {
    var environment: Environment
    enum Environment: String {
        /// Used in production
        case prod = "https://api.exchangeratesapi.io/"
        /// Used for dev envs
        case dev = ""
        /// Used only for tests
        case mock = "https://mock.localhost/"
    }

    var host: String { environment.rawValue }

    init(env: Environment) {
        self.environment = env
        super.init(host: env.rawValue)
    }
}
