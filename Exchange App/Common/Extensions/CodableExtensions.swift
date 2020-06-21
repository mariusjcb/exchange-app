//
//  JSONEncoderExtensions.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

extension JSONEncoder {
    static func withDateFormat(_ dateFormat: DateFormatter.Formats) -> JSONEncoder {
        return withDateFormatter(dateFormat.formatter)
    }

    static func withDateFormatter(_ dateFormatter: DateFormatter) -> JSONEncoder {
        return JSONEncoder().settingDateFormatter(dateFormatter)
    }

    func settingDateFormatter(_ dateFormatter: DateFormatter) -> JSONEncoder {
        self.dateEncodingStrategy = .formatted(dateFormatter)
        return self
    }
}

extension JSONDecoder {
    static func withDateFormat(_ dateFormat: DateFormatter.Formats) -> JSONDecoder {
        return withDateFormatter(dateFormat.formatter)
    }

    static func withDateFormatter(_ dateFormatter: DateFormatter) -> JSONDecoder {
        return JSONDecoder().settingDateFormatter(dateFormatter)
    }

    func settingDateFormatter(_ dateFormatter: DateFormatter) -> JSONDecoder {
        self.dateDecodingStrategy = .formatted(dateFormatter)
        return self
    }
}
