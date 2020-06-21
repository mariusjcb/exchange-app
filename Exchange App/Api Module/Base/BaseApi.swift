//
//  BaseApi.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class BaseApi: NSObject {

    private let requestAdapter: BaseRequestAdapter
    let httpClient: Alamofire.SessionManager

    var encoder: JSONEncoder { return JSONEncoder() }
    var decoder: JSONDecoder { return JSONDecoder() }

    init(requestAdapter: BaseRequestAdapter, httpClient: Alamofire.SessionManager? = nil) {
        self.requestAdapter = requestAdapter
        self.httpClient = httpClient ?? .makeDefaultSession(with: requestAdapter)
    }

    func request<T: Decodable>(_ method: Alamofire.HTTPMethod,
                               _ url: Alamofire.URLConvertible,
                               parameters: [String : Any]? = nil,
                               encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                               headers: [String : String]? = nil) -> Observable<T> {
        return httpClient.rx.request(method, url, parameters: parameters, encoding: encoding, headers: headers, decoder: decoder)
    }

}
