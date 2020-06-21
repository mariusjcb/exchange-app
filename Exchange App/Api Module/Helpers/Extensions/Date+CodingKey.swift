//
//  Date+CodingKey.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

extension Date: CodingKey {
    public var stringValue: String {
        return convert(to: .default)
    }

    public init?(stringValue: String) {
        let date = stringValue.convert(to: .default)
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
