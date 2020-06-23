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
    var content: Driver<Model?> { get }
}

public protocol LoadableViewModel: class {
    var isStarted: Driver<Bool> { get }
    var loading: Driver<Bool> { get }
    var error: Driver<Error?> { get }
}

public protocol ActionableViewModel: class {
    associatedtype Model
    associatedtype ActionType: CaseIterable
    func dispatch(_ action: ActionType)
    func accept(model: Model)
    func reject(error: Error)
}
