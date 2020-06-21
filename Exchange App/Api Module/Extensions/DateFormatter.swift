//
//  DateFormatter.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

extension DateFormatter {
    enum Formats: String {
        case dateOnly = "yyyy--MM--dd"

        var formatter: DateFormatter {
            return DateFormatter.from(rawValue)
        }
    }

    static func from(_ format: String) -> DateFormatter {
        return DateFormatter().withFormat(format)
    }

    @discardableResult
    func withFormat(_ format: String) -> DateFormatter {
        self.dateFormat = format
        return self
    }
}

extension Date {
    func convert(to format: DateFormatter.Formats) -> String {
        return format.formatter.string(from: self)
    }
}
