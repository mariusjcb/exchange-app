//
//  BaseRequestAdapter.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire

open class BaseRequestAdapter: Alamofire.RequestAdapter {
    private let host: String

    public init(host: String) {
        self.host = host
    }

    open func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        let url = urlRequest.url?.absoluteString ?? ""
        urlRequest.url = URL(string: "\(host.dropLast())\(url)")

        return urlRequest
    }
}

extension BaseRequestAdapter: Alamofire.RequestRetrier {
    public func should(_ manager: Alamofire.SessionManager, retry request: Alamofire.Request, with error: Error, completion: @escaping Alamofire.RequestRetryCompletion) {
        completion(false, 0.0)
    }
}
