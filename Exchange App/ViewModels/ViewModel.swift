//
//  BaseViewModel.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol ViewModel: class {
    associatedtype Model
    associatedtype ActionType: CaseIterable

    var loading: Driver<Bool> { get }
    var content: Driver<Model?> { get }
    var error: Driver<Error?> { get }

    func dispatch(_ action: ActionType)

    func accept(model: Model)
    func reject(error: Error)
}
