//
//  EncodableExtensions.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

extension Encodable {
    func toDictionary(using encoder: JSONEncoder) throws -> [String: Any] {
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw ParseError.wrongInputType
        }
        return dictionary
    }
}
