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

final class FetchImageUseCaseImplTests: XCTestCase {
    
    private var fetchImageUseCase: FetchImageUseCase!
    private var mockImage: MockImage!
    private var imageCache: ImageCache!
    private var disposeBag: DisposeBag!

    override func setUp() {
        imageCache = ImageCache(cache: NSCache<NSURL, NSData>())
        // TODO: Mock Server 주입 필요
        disposeBag = DisposeBag()
        mockImage = MockImage()
    }
    
    func test_캐시데이터에_이미지가_존재하는_경우_이미지_데이터를_담은_옵저버를_반환한다() throws {
        // Given
        let urlString = "test_cache_image_URL"
        let imageData = mockImage.getImageData(url: "CacheImage") as NSData
        guard let url = NSURL(string: urlString) else {
            XCTFail("데이터 변환 실패")
            return
        }
        imageCache.setImageData(imageData, for: url)
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
            XCTAssertEqual(Data(imageData), result)
        } catch let error {
            XCTFail("캐시데이터 이미지 fetch 실패")
        }
        
    }

    func test_캐시데이터에_이미지가_존재하지_않는_경우_서버에서_받아온_이미지_데이터를_담은_옵저버를_반환한다() throws {
        // Given
        let imageData = mockImage.getImageData(url: "NoCacheImage") as NSData
        let urlString = "test_no_cache_image_URL"
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
            XCTAssertEqual(Data(imageData), result)
        } catch {
            XCTFail("캐시데이터 이미지 fetch 실패")
        }
    }
    
    func test_URL에_맞는_이미지_데이터가_없는_경우_ImageRepositoryError를_담은_옵저버를_반환한다() throws {
        // Given
        let urlString = "test_no_image_URL"
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
            guard let error = error as? ImageRepositoryError else {
                XCTFail("ImageRepositoryError 에러를 담은 데이터를 반환 실패")
                return
            }
            XCTAssertEqual(ImageRepositoryError.noImageData, error)
        }
    }
    
    func test_API_호출이_실패한_경우_서버_ErrorAlertMessage를_담은_옵저버를_반환한다() throws {
        // Given
        let urlString = "test_fail_API_URL"
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
            guard let error = error as? ErrorAlertMessage else {
                XCTFail("ErrorAlertMessage 에러를 담은 데이터를 반환 실패")
                return
            }
            XCTAssertEqual(ErrorAlertMessage.server, error)
        }
    }
    
}
