//
//  AppSettingsTests.swift
//  Exchange AppTests
//
//  Created by Marius Ilie on 23/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import XCTest
@testable import Exchange_App

class AppSettingsTests: XCTestCase {

    func testAppSettingsInitWithDefaultValues() {
        let sutData = AppDefaults.DefaultAppSettings
        let appSettings = AppSettings(sutData.defaultCurrency,
                                      sutData.refreshRate,
                                      sutData.autorefreshHistory,
                                      sutData.historyStartDate,
                                      sutData.historyEndDate,
                                      sutData.selectedHistorySymbols)

        XCTAssertEqual(appSettings.defaultCurrency, sutData.defaultCurrency)
        XCTAssertEqual(appSettings.refreshRate, sutData.refreshRate)
        XCTAssertEqual(appSettings.autorefreshHistory, sutData.autorefreshHistory)
        XCTAssertEqual(appSettings.historyStartDate, sutData.historyStartDate)
        XCTAssertEqual(appSettings.historyEndDate, sutData.historyEndDate)
        XCTAssertEqual(appSettings.selectedHistorySymbols, sutData.selectedHistorySymbols)
    }
}
