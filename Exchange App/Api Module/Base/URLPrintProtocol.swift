//
//  Debug.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import Alamofire

/// It doesn't take any effect on production but will help us to know requests and curls right in the console log
protocol URLPrintProtocol: class {
    static func print(_ response: (HTTPURLResponse, Data))
    static func print(_ request: Alamofire.DataRequest)
    static func print(_ request: URLRequest)
    static func print(_ error: Error)
}
#if DEBUG
extension URLPrintProtocol {
    static func print(_ request: URLRequest) {
        Swift.print()
        Swift.print("🚀 Running request: \(request.httpMethod ?? "") - \(request.url?.absoluteString ?? "")")

        if let headers = request.allHTTPHeaderFields, headers.count > 0 {
            Swift.print("\t● Headers: \(headers)")
        }

        if let stream = request.httpBodyStream {
            let data = Data(reading: stream)
            Swift.print("\t● Body: \(String(describing: String(data: data, encoding: .utf8) ?? ""))")
        }

        Swift.print()
    }

    static func print(_ request: DataRequest) {
        Swift.print()
        Swift.print("🧩 cURL Request:")
        debugPrint(request)
        Swift.print()
    }

    static func print(_ response: (HTTPURLResponse, Data)) {
        Swift.print()
        Swift.print("✅ Request Completed: \(response.0.url?.absoluteString ?? "")")
        Swift.print("\t● Status Code: \(response.0.statusCode)")

        let headers = response.0.allHeaderFields
        if  headers.count > 0 {
            Swift.print("\t● Headers: \(headers)")
        }

        Swift.print("\t● Body: \(String(describing: String(data: response.1, encoding: .utf8) ?? ""))")
        Swift.print()
    }

    static func print(_ error: Error) {
        Swift.print()
        Swift.print("⛔️ Request Error: \(error.localizedDescription)")
        Swift.print()
    }
}
#else
extension URLPrintProtocol {
    static func print(_ request: DataRequest) { }
    static func print(_ request: URLRequest) { }
    static func print(_ response: (HTTPURLResponse, Data)) { }
    static func print(_ error: Error) { }
}
#endif

final class RequestPrintProtocol: URLProtocol, URLPrintProtocol {
    override public class func canInit(with request: URLRequest) -> Bool {
        print(request)
        return false
    }
}
