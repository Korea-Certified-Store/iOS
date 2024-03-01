//
//  FetchImageRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/26/24.
//

import XCTest
@testable import KCS
import Alamofire
import RxSwift
import RxBlocking

struct FetchImageRepositoryImplTestsConstant {
    
    enum urlString: String {
        
        case cache = "test_cache_image_URL"
        case noCache = "test_no_cache_image_URL"
        case fail = "url"
        case wrongURL = ""
        
    }
    
}

final class FetchImageRepositoryImplTests: XCTestCase {
    
    private var fetchImageRepository: FetchImageRepositoryImpl!
    private var imageCache: ImageCache!
    private var mockImage: MockImage!
    private var session: Session!
    private let imageString = "MockImage"

    override func setUp() {
        imageCache = ImageCache(cache: NSCache<NSURL, NSData>())
        mockImage = MockImage()
        session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        fetchImageRepository = FetchImageRepositoryImpl(
            cache: imageCache,
            session: session
        )
    }

    func test_캐시데이터에_이미지가_존재하고_통신에_성공한_경우() {
        // Given
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchImageFile)
        let urlString = FetchImageRepositoryImplTestsConstant.urlString.cache.rawValue
        let imageData = mockImage.getImageURL()
        guard let url = NSURL(string: urlString) else {
            XCTFail("데이터 변환 실패")
            return
        }
        imageCache.setImageData(imageData as NSData, for: url)
        fetchImageRepository = FetchImageRepositoryImpl(
            cache: imageCache,
            session: session
        )
        
        // When
        let imageObservable = fetchImageRepository.fetchImage(url: urlString).toBlocking()
        
        // Then
        do {
            guard let result = try imageObservable.first() else {
                XCTFail("BlockingObservable 값 추출 실패")
                return
            }
            XCTAssertEqual(Data(imageData), result)
        } catch {
            XCTFail("캐시데이터 이미지 fetch 실패")
        }
    }
    
    func test_캐시데이터에_이미지가_존재하지_않고_통신에_성공한_경우() {
        // Given
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchImageFile)
        let urlString = FetchImageRepositoryImplTestsConstant.urlString.noCache.rawValue
        let imageData = mockImage.getImageURL()
        fetchImageRepository = FetchImageRepositoryImpl(
            cache: imageCache,
            session: session
        )
        
        // When
        let imageObservable = fetchImageRepository.fetchImage(url: urlString).toBlocking()
        
        // Then
        do {
            guard let result = try imageObservable.first() else {
                XCTFail("BlockingObservable 값 추출 실패")
                return
            }
            XCTAssertEqual(Data(imageData), result)
        } catch {
            XCTFail("캐시데이터 이미지 fetch 실패")
        }
    }
    
    func test_URL에_맞는_이미지_데이터가_존재하지_않는_경우() {
        // Given
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchImageFileFail)
        let urlString = FetchImageRepositoryImplTestsConstant.urlString.fail.rawValue
        fetchImageRepository = FetchImageRepositoryImpl(
            cache: imageCache,
            session: session
        )
        
        // When
        let imageObservable = fetchImageRepository.fetchImage(url: urlString).toBlocking().materialize()
        
        // Then
        switch imageObservable {
        case .completed(_):
            XCTFail("ImageRepositoryError 에러를 담은 데이터를 반환 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ImageRepositoryError, ImageRepositoryError.noImageData)
        }
    }
    
    func test_잘못된_URL을_요청했을_경우() {
        // Given
        MockURLProtocol.responseWithStatusCode(code: 200)
        MockURLProtocol.setResponseFile(type: .fetchImageFileFail)
        let urlString = FetchImageRepositoryImplTestsConstant.urlString.wrongURL.rawValue
        fetchImageRepository = FetchImageRepositoryImpl(
            cache: imageCache,
            session: session
        )
        
        // When
        let imageObservable = fetchImageRepository.fetchImage(url: urlString).toBlocking().materialize()
        
        // Then
        switch imageObservable {
        case .completed(_):
            XCTFail("ErrorAlertMessage.client 에러를 담은 데이터를 반환 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.client)
        }
    }
    
    func test_인터넷_연결에_실패한_경우() {
        // Given
        MockURLProtocol.responseWithFailure(error: .noInternetConnection)
        let urlString = FetchImageRepositoryImplTestsConstant.urlString.fail.rawValue
        fetchImageRepository = FetchImageRepositoryImpl(
            cache: imageCache,
            session: session
        )
        
        // When
        let imageObservable = fetchImageRepository.fetchImage(url: urlString).toBlocking().materialize()
        
        // Then
        switch imageObservable {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.internet)
        }
    }
    
    func test_서버_연결에_실패한_경우() {
        // Given
        MockURLProtocol.responseWithFailure(error: .noServerConnection)
        let urlString = FetchImageRepositoryImplTestsConstant.urlString.fail.rawValue
        fetchImageRepository = FetchImageRepositoryImpl(
            cache: imageCache,
            session: session
        )
        
        // When
        let imageObservable = fetchImageRepository.fetchImage(url: urlString).toBlocking().materialize()
        
        // Then
        switch imageObservable {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.server)
        }
    }
    
    func test_Alamofire_통신에_실패한_경우() {
        // Given
        MockURLProtocol.responseWithFailure(error: .alamofireError)
        let urlString = FetchImageRepositoryImplTestsConstant.urlString.fail.rawValue
        fetchImageRepository = FetchImageRepositoryImpl(
            cache: imageCache,
            session: session
        )
        
        // When
        let imageObservable = fetchImageRepository.fetchImage(url: urlString).toBlocking().materialize()
        
        // Then
        switch imageObservable {
        case .completed:
            XCTFail("Error 방출 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.client)
        }
    }
    
}
