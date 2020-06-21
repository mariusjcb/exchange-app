//
//  RequestParamRepresentable.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

protocol RequestParamRepresentable: Codable {
    associatedtype Model
    init(from model: Model)
}

// MARK: - Helpers

protocol StringRawRepresentable: Codable, RawRepresentable where RawValue: StringProtocol { }
