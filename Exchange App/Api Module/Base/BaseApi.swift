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

/// Use this class as base for all apis. This will provide you request methods and logic for easy ways to request data.
open class BaseApi: NSObject {

    private let requestAdapter: BaseRequestAdapter
    let httpClient: Alamofire.SessionManager

    open var encoder: JSONEncoder { return JSONEncoder() }
    open var decoder: JSONDecoder { return JSONDecoder() }

    public init(requestAdapter: BaseRequestAdapter, httpClient: Alamofire.SessionManager? = nil) {
        self.requestAdapter = requestAdapter
        self.httpClient = httpClient ?? .makeDefaultSession(with: requestAdapter)
    }

    open func request<T: Decodable>(_ method: Alamofire.HTTPMethod,
                               _ url: Alamofire.URLConvertible,
                               params: [String: Any]? = nil,
                               encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                               headers: [String: String]? = nil) -> Observable<T> {
        return httpClient.rx.request(method, url, parameters: params, encoding: encoding, headers: headers, decoder: decoder)
    }
}

// MARK: - Wrappers

extension BaseApi {
    func request<P: RequestParamRepresentable, H: RequestParamRepresentable, T: Decodable>(paramType: P.Type,
                                                                                           headerType: H.Type,
                                                                                           _ method: Alamofire.HTTPMethod,
                                                                                           _ url: Alamofire.URLConvertible,
                                                                                           params: P.Model? = nil,
                                                                                           encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                                                                                           headers: H.Model? = nil) -> Observable<T> {
        return request(method, url, params: paramsValue(P.self, from: params), encoding: encoding, headers: headerValue(H.self, from: headers))
    }

    func request<P: RequestParamRepresentable, T: Decodable>(with paramType: P.Type,
                                                             _ method: Alamofire.HTTPMethod,
                                                             _ url: Alamofire.URLConvertible,
                                                             params: P.Model? = nil,
                                                             encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                                                             headers: [String: String]? = nil) -> Observable<T> {
        return request(method, url, params: paramsValue(P.self, from: params), encoding: encoding, headers: headers)
    }

    func request<H: RequestParamRepresentable, T: Decodable>(with headerType: H.Type,
                                                             _ method: Alamofire.HTTPMethod,
                                                             _ url: Alamofire.URLConvertible,
                                                             params: [String: Any]? = nil,
                                                             encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                                                             headers: H.Model? = nil) -> Observable<T> {
        return request(method, url, params: params, encoding: encoding, headers: headerValue(H.self, from: headers))
    }

    func request<P: RequestParamRepresentable, H: RequestParamRepresentable, T: Decodable>(_ method: Alamofire.HTTPMethod,
                                                                                           _ url: Alamofire.URLConvertible,
                                                                                           params: P? = nil,
                                                                                           encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                                                                                           headers: H? = nil) -> Observable<T> {
        return request(method, url, params: paramsValue(from: params), encoding: encoding, headers: headerValue(from: headers))
    }

    func request<P: RequestParamRepresentable, T: Decodable>(_ method: Alamofire.HTTPMethod,
                                                             _ url: Alamofire.URLConvertible,
                                                             params: P? = nil,
                                                             encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                                                             headers: [String: String]? = nil) -> Observable<T> {
        return request(method, url, params: paramsValue(from: params), encoding: encoding, headers: headers)
    }

    func request<H: RequestParamRepresentable, T: Decodable>(_ method: Alamofire.HTTPMethod,
                                                             _ url: Alamofire.URLConvertible,
                                                             params: [String: Any]? = nil,
                                                             encoding: Alamofire.ParameterEncoding = URLEncoding.default,
                                                             headers: H? = nil) -> Observable<T> {
        return request(method, url, params: params, encoding: encoding, headers: headerValue(from: headers))
    }
}

extension BaseApi {
    func headerValue<H: RequestParamRepresentable>(_ type: H.Type, from model: H.Model?) -> [String: String]? {
        guard let model = model else { return nil }
        return headerValue(from: H(from: model))
    }

    func paramsValue<P: RequestParamRepresentable>(_ type: P.Type, from model: P.Model?) -> [String: Any]? {
        guard let model = model else { return nil }
        return paramsValue(from: P(from: model))
    }

    func headerValue<H: RequestParamRepresentable>(from element: H?) -> [String: String]? {
        guard let element = element else { return nil }
        let headerValue = try? element.toDictionary(using: encoder) as? [String: String]

        #if DEBUG
        if headerValue == nil {
            assertionFailure("Header should be a [String: String] dictionary. Your model: \(element) \(#file):\(#line)")
        }
        #endif

        return headerValue
    }

    func paramsValue<P: RequestParamRepresentable>(from element: P?) -> [String: Any]? {
        guard let element = element else { return nil }
        return try? element.toDictionary(using: encoder)
    }
}
