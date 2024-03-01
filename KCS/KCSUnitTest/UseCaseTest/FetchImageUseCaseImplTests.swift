//
//  FetchImageUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/25/24.
//

import XCTest
@testable import KCS
import RxSwift
import RxBlocking

struct FetchImageUseCaseImplTestsConstant {
    
    enum MockURLString: String {
        
        case cache = "test_cache_image_URL"
        case noCache = "test_no_cache_image_URL"
        case fail = "url"
        
    }
    
}

final class FetchImageUseCaseImplTests: XCTestCase {
    
    private var fetchImageUseCase: FetchImageUseCase!
    private var imageCache: ImageCache!
    private var disposeBag: DisposeBag!
    private var mockImage: MockImage!
    private let imageString = "MockImage"

    override func setUp() {
        imageCache = ImageCache(cache: NSCache<NSURL, NSData>())
        mockImage = MockImage()
        disposeBag = DisposeBag()
    }
    
    func test_캐시데이터에_이미지가_존재하는_경우() {
        // Given
        let urlString = FetchImageUseCaseImplTestsConstant.MockURLString.cache.rawValue
        guard let url = NSURL(string: urlString) else {
            XCTFail("데이터 변환 실패")
            return
        }
        let imageData = mockImage.getImageURL()
        imageCache.setImageData(imageData as NSData, for: url)
        fetchImageUseCase = FetchImageUseCaseImpl(
            repository: MockSuccessImageRepository(
                cache: imageCache
            )
        )
        
        // When
        let imageUseCaseObservable = fetchImageUseCase.execute(url: urlString).toBlocking()
        
        // Then
        do {
            guard let result = try imageUseCaseObservable.first() else {
                XCTFail("BlockingObservable 값 추출 실패")
                return
            }
            XCTAssertEqual(result, imageData)
        } catch {
            XCTFail("캐시데이터 이미지 fetch 실패")
        }
        
    }

    func test_캐시데이터에_이미지가_존재하지_않는_경우() {
        // Given
        let urlString = FetchImageUseCaseImplTestsConstant.MockURLString.noCache.rawValue
        let imageData = mockImage.getImageURL()
        fetchImageUseCase = FetchImageUseCaseImpl(
            repository: MockSuccessImageRepository(
                cache: imageCache
            )
        )
        
        // When
        let imageUseCaseObservable = fetchImageUseCase.execute(url: urlString).toBlocking()
        
        // Then
        do {
            guard let result = try imageUseCaseObservable.first() else {
                XCTFail("BlockingObservable 값 추출 실패")
                return
            }
            XCTAssertEqual(result, imageData)
        } catch {
            XCTFail("캐시데이터 이미지 fetch 실패")
        }
    }
    
    func test_URL에_맞는_이미지_데이터가_없는_경우() {
        // Given
        let urlString = FetchImageUseCaseImplTestsConstant.MockURLString.fail.rawValue
        fetchImageUseCase = FetchImageUseCaseImpl(
            repository: MockNoImageFailureImageRepository(
                cache: imageCache
            )
        )
        
        // When
        let imageUseCaseObservable = fetchImageUseCase.execute(url: urlString).toBlocking().materialize()
        
        // Then
        switch imageUseCaseObservable {
        case .completed(_):
            XCTFail("ImageRepositoryError 에러를 담은 데이터를 반환 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ImageRepositoryError, ImageRepositoryError.noImageData)
        }
    }
    
    func test_API_호출이_실패한_경우() {
        // Given
        let urlString = FetchImageUseCaseImplTestsConstant.MockURLString.fail.rawValue
        fetchImageUseCase = FetchImageUseCaseImpl(
            repository: MockAPIFailureImageRepository(
                cache: imageCache
            )
        )
        
        // When
        let imageUseCaseObservable = fetchImageUseCase.execute(url: urlString).toBlocking().materialize()
        
        // Then
        switch imageUseCaseObservable {
        case .completed(_):
            XCTFail("ErrorAlertMessage 에러를 담은 데이터를 반환 실패")
        case .failed(_, let error):
            XCTAssertEqual(error as? ErrorAlertMessage, ErrorAlertMessage.server)
        }
    }
    
}
