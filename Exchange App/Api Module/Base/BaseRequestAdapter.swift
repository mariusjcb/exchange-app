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

public protocol AuthorizationAdapterDelegate: class {
    func requestRetrier(_ requestRetrier: RequestRetrier, didReceiveAuthorizationError error: Error, for request: Alamofire.Request, retryRequest: @escaping ((Bool) -> ()))
    func requestAdapter(_ requestAdapter: RequestAdapter, authorizationTokenFor urlRequest: URLRequest) -> String?
}

public extension BaseRequestAdapter {
    enum HeaderKeys: String {
        case authKey = "x-auth-key"
    }
}

open class BaseRequestAdapter: Alamofire.RequestAdapter {

    private let host: String

    open var authorizationDelegate: AuthorizationAdapterDelegate?

    public init(host: String, authorizationDelegate: AuthorizationAdapterDelegate? = nil) {
        self.host = host
        self.authorizationDelegate = authorizationDelegate
    }

    open func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        let url = urlRequest.url?.absoluteString ?? ""
        urlRequest.url = URL(string: "\(host.dropLast())\(url)")

        if let accessToken = authorizationDelegate?.requestAdapter(self, authorizationTokenFor: urlRequest) {
            urlRequest.setValue(accessToken, forHTTPHeaderField: HeaderKeys.authKey.rawValue)
        }

        return urlRequest
    }
}

extension BaseRequestAdapter: Alamofire.RequestRetrier {
    public func should(_ manager: Alamofire.SessionManager, retry request: Alamofire.Request, with error: Error, completion: @escaping Alamofire.RequestRetryCompletion) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(false, 0.0)
            return
        }

        authorizationDelegate?.requestRetrier(self, didReceiveAuthorizationError: error, for: request) { success in
            completion(success, 0.0)
        }
    }
}
