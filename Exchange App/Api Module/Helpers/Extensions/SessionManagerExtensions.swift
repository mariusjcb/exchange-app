//
//  SessionManagerExtensions.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import Alamofire

extension Alamofire.SessionManager {
    class func makeDefaultSession(with adapter: Alamofire.RequestAdapter, cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalCacheData, protocolClasses: [AnyClass]? = [RequestPrintProtocol.self]) -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders

        configuration.requestCachePolicy = cachePolicy
        configuration.timeoutIntervalForResource = 10
        configuration.timeoutIntervalForRequest = 10

        protocolClasses?.forEach { type in
            configuration.protocolClasses?.insert(type, at: 0)
        }

        let httpSession = Alamofire.SessionManager(configuration: configuration)
        httpSession.adapter = adapter
        return httpSession
    }
}
