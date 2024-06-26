//
//  BaseViewModelTest.swift
//  EasyCryptoTests
//
//  Created by Mehran Kamalifard on 5/3/23.
//

import XCTest
import Combine
@testable import EasyCrypto

final class BaseViewModelTest: XCTestCase {
    
    private var remote: MarketPriceRemoteMock!
    private var viewModelToTest: DefaultViewModel!
    private var subscriber : Set<AnyCancellable> = []

    override func setUp()  {
        remote = MarketPriceRemoteMock()
        viewModelToTest = DefaultViewModel()
    }
    
    override func tearDown() {
        subscriber.forEach { $0.cancel() }
        subscriber.removeAll()
        remote = nil
        viewModelToTest = nil
        super.tearDown()
    }
    
    func testBaseViewModel_WhenCallWithProgress_ShouldReturnValue() {
        //Arrange
        let data = MarketsPrice.mockArray
        
        remote.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "State is set to Token")
        let viewModel = self.viewModelToTest
        // Act
        viewModel?.loadingState.dropFirst().sink { event in
            expectation.fulfill()
            XCTAssertEqual(event, .loadStart)
        }.store(in: &subscriber)

        viewModel?.call(argument: self.remote.fetch(vs_currency: .empty,
                                                                order: .empty,
                                                                per_page: 1,
                                                                page: 1,
                
                                                                sparkline: false)) { data in
        // Assert
        expectation.fulfill()
        XCTAssertTrue(data as Any is [MarketsPrice])
        XCTAssertTrue(data as Any is Decodable)
        }
        
        viewModel?.loadingState.dropFirst().sink(receiveValue: { event in
            expectation.fulfill()
            XCTAssertEqual(event, .dismissAlert)
        }).store(in: &subscriber)

        wait(for: [expectation], timeout: 1)
    }
    
    func testBaseViewModel_WhenCallWithProgress_ShouldReturnNil() {
        //Arrange
        let data: [MarketsPrice] = []
        
        remote.fetchedResult = Result.success(data).publisher.eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "State is set to Token")
        
        let viewModel = self.viewModelToTest
        // Act
        viewModel?.call(argument: self.remote.fetch(vs_currency: .empty,
                                                                   order: .empty,
                                                                per_page: 1,
                                                                page: 1,
                                                                sparkline: false)) { data in
        // Assert
        expectation.fulfill()
        XCTAssertTrue(data as Any is [MarketsPrice])
        }

        wait(for: [expectation], timeout: 1)
    }
}
