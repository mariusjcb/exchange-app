//
//  CodableDictionary.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

struct RatesResponseTypeDecoder<Key: Hashable, Value: Codable>: Codable where Key: CodingKey {
    let decoded: [Key: Value]

    init(_ decoded: [Key: Value]) {
        self.decoded = decoded
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        decoded = Dictionary(uniqueKeysWithValues:
            try container.allKeys.lazy.map {
                (key: $0, value: try RatesResponseType.decode(Value.self, from: container, forKey: $0) ?? container.decode(Value.self, forKey: $0))
            })
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        for (key, value) in decoded {
            try container.encode(value, forKey: key)
        }
    }
}
