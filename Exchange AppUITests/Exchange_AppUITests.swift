//
//  Exchange_AppUITests.swift
//  Exchange AppUITests
//
//  Created by Marius Ilie on 20/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import XCTest

class Exchange_AppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
