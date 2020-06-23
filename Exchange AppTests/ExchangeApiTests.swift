//
//  ExchangeApiTests.swift
//  Exchange AppTests
//
//  Created by Marius Ilie on 23/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import XCTest
import OHHTTPStubsSwift
import RxSwift
import RxTest
@testable import Exchange_App

class ExchangeApiTests: XCTestCase {

    var rx_disposeBag: DisposeBag!
    var sut: ExchangeRatesApi!
    let exchangeRequestAdapter = ExchangeApiRequestAdapter(env: .mock)

    override func setUp() {
        super.setUp()
        rx_disposeBag = DisposeBag()
        sut = .init(requestAdapter: exchangeRequestAdapter)
    }

    func testExchangeApiWithCurrencyShouldResponseValidRates() {
        let testScheduler = TestScheduler(initialClock: 0)
        stub(condition: isHost("mock.localhost")) { _ in
            return fixture(filePath: "MockData/latestRates.json", headers: ["Content-Type":"application/json"])
        }

        let fileURL = Bundle(for: type(of: self)).url(forResource: "latestRates", withExtension: "json")
        var expectedResponse: RatesResponse<RatesResponseType.Default>!
        if let fileURL = fileURL {
            do {
                let data = try Data(contentsOf: fileURL)
                expectedResponse = try sut.decoder.decode(RatesResponse<RatesResponseType.Default>.self, from: data)
                XCTAssertNotNil(expectedResponse)
            } catch {
                XCTAssert(false)
            }
        }

        let observer = testScheduler.createObserver(RatesResponse<RatesResponseType.Default>.self)
        self.sut
            .requestRates(currency: .EUR)
            .subscribe(observer)
            .disposed(by: self.rx_disposeBag)
        testScheduler.start()

        XCTAssertEqual(observer.events.first?.value.element?.rates, expectedResponse.rates)
    }
}
