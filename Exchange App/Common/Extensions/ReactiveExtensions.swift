//
//  ReactiveExtensions.swift
//  Exchange App
//
//  Created by Marius Ilie on 21/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func asVoid() -> Observable<Void> {
        self.map { _ in }
    }

    func asVoid(skip: Int) -> Observable<Void> {
        self.asVoid().skip(skip)
    }
}
