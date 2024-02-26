//
//  FetchImageRepositoryTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/26/24.
//

import XCTest
@testable import KCS
import Alamofire
import RxSwift

final class FetchImageRepositoryTests: XCTestCase {
    
    private var fetchImageRepository: FetchImageRepository!
    private var imageCache: ImageCache!
    private var session: Session!

    override func setUp() {
        imageCache = ImageCache()
        session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        fetchImageUseCase = FetchImageRepositoryImpl(cache: imageCache, session: session)
    }

    func test() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
