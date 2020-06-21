//
//  RxAlamofireExtensions.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift

extension Reactive where Base == Alamofire.SessionManager {
    public func request<T: Decodable>(_ method: Alamofire.HTTPMethod,
                                      _ url: Alamofire.URLConvertible,
                                      parameters: [String : Any]? = nil,
                                      encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                                      headers: [String : String]? = nil,
                                      decoder: JSONDecoder) -> Observable<T> {
        return self.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
            .decode(T.self, with: decoder)
    }
}

extension ObservableType where Self.Element == Alamofire.DataRequest {
    func decode<E: Decodable>(_ type: E.Type, with decoder: JSONDecoder) -> Observable<E> {
        return self.data().map { try decoder.decode(E.self, from: $0) }
    }

    func validateHttpStatus() -> Observable<((HTTPURLResponse, Data))> {
        return self.responseData().flatMap { response -> Observable<((HTTPURLResponse, Data))> in
            guard response.0.statusCode < 200 || response.0.statusCode > 300 else { return .from(optional: response) }

            if let errorMessage = String(data: response.1, encoding: .utf8) {
                return .error(ApiError.custom(errorMessage))
            } else {
                return .error(ApiError.unknown)
            }
        }
    }

    func bodyMessage() -> Observable<String> {
        return self.responseData().map { String(data: $0.1, encoding: .utf8)! }
    }
}

extension ObservableType where Self.Element == (HTTPURLResponse, Data) {
    func decode<E: Decodable>(_ type: E.Type, with decoder: JSONDecoder) -> Observable<E> {
        return self.map { try decoder.decode(E.self, from: $0.1) }
    }

    func data() -> Observable<Data> {
        return self.map { $0.1 }
    }

    func bodyMessage() -> Observable<String> {
        return self.map { String(data: $0.1, encoding: .utf8)! }
    }
}
