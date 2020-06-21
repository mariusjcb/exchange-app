//
//  ApiError.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation

enum ApiError: Error, Equatable {
    case unknown
    case custom(String)
}
