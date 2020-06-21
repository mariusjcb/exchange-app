//
//  CodableDictionary.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

extension Date: CodingKey {
    public var stringValue: String {
        return convert(to: .dateOnly)
    }

    public init?(stringValue: String) {
        let date = stringValue.convert(to: .dateOnly)
        guard let interval = date?.timeIntervalSince1970 else {
            return nil
        }
        self.init(timeIntervalSince1970: interval)
    }

    public var intValue: Int? {
        return Int(self.timeIntervalSince1970)
    }

    public init?(intValue: Int) {
        self.init(timeIntervalSince1970: TimeInterval(intValue))
    }
}

struct RatesResponseTypeDecoder<Key: Hashable, Value: Codable>: Codable where Key: CodingKey {
    let decoded: [Key: Value]

    init(_ decoded: [Key: Value]) {
        self.decoded = decoded
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        decoded = Dictionary(uniqueKeysWithValues:
            try container.allKeys.lazy.map {
                (key: $0, value: try RatesResponseType.decode(Value.self, from: container, forKey: $0)!)
            })
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        for (key, value) in decoded {
            try container.encode(value, forKey: key)
        }
    }
}
