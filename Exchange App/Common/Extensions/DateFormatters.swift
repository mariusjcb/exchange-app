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
        case dateOnly = "yyyy-MM-dd"

        static var `default`: Formats {
            .dateOnly
        }
    }
}

// MARK: - Helpers

extension DateFormatter {
    static func from(_ format: String) -> DateFormatter {
        return DateFormatter().withFormat(format)
    }

    @discardableResult
    func withFormat(_ format: String) -> DateFormatter {
        self.dateFormat = format
        return self
    }
}

extension DateFormatter.Formats {
    var formatter: DateFormatter {
        return DateFormatter.from(rawValue)
    }
}

extension Date {
    func convert(to format: DateFormatter.Formats) -> String {
        return format.formatter.string(from: self)
    }
}

extension String {
    func convert(to format: DateFormatter.Formats) -> Date? {
        return format.formatter.date(from: self)
    }
}
