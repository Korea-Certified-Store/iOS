//
//  FetchImageUseCaseImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 2/25/24.
//

import XCTest
@testable import KCS
import RxSwift

final class FetchImageUseCaseImplTests: XCTestCase {
    
    private var fetchImageUseCase: FetchImageUseCase!
    private var imageCache: ImageCache!
    private var storeAPI: Router!
    private var disposeBag: DisposeBag!

    override func setUp() {
        imageCache = ImageCache(cache: NSCache<NSURL, NSData>())
        // TODO: Mock Server 주입 필요
        storeAPI = StoreAPI(type: .getImage)
        disposeBag = DisposeBag()
    }
    
    func test_캐시데이터에_이미지가_존재하는_경우_이미지_데이터를_담은_옵저버를_반환한다() throws {
        let expectation = XCTestExpectation(description: "test_fetch_imageData_in_cache_success")
        let urlString = "test_cache_image_URL"
        
        guard let url = NSURL(string: urlString),
              let imageData = "cache_image".data(using: .utf8) as? NSData else { return }
        imageCache.setImageData(imageData, for: url)
        fetchImageUseCase = FetchImageUseCaseImpl(
            repository: MockSuccessImageRepository(
                cache: imageCache,
                storeAPI: storeAPI
            )
        )
        fetchImageUseCase.execute(url: urlString)
            .subscribe { data in
                if data == Data(imageData) {
                    expectation.fulfill()
                }
            }
            .disposed(by: disposeBag)
        
        wait(for: [expectation])
    }

    func test_캐시데이터에_이미지가_존재하지_않는_경우_서버에서_받아온_이미지_데이터를_담은_옵저버를_반환한다() throws {
        let expectation = XCTestExpectation(description: "test_fetch_imageData_success")
        let expectData = "no_cache".data(using: .utf8)
        let urlString = "test_no_cache_image_URL"
        fetchImageUseCase = FetchImageUseCaseImpl(
            repository: MockSuccessImageRepository(
                cache: imageCache,
                storeAPI: storeAPI
            )
        )
        fetchImageUseCase.execute(url: urlString)
            .subscribe { data in
                if data == expectData {
                    expectation.fulfill()
                }
            }
            .disposed(by: disposeBag)
        
        wait(for: [expectation])
    }
    
    func test_URL에_맞는_이미지_데이터가_없는_경우_ImageRepositoryError를_담은_옵저버를_반환한다() throws {
        let expectation = XCTestExpectation(description: "test_fetch_imageData_failure")
        let urlString = "test_no_image_URL"
        fetchImageUseCase = FetchImageUseCaseImpl(
            repository: MockNoImageFailureImageRepository(
                cache: imageCache,
                storeAPI: storeAPI
            )
        )
        fetchImageUseCase.execute(url: urlString)
            .subscribe(onError: { error in
                if error as? ImageRepositoryError == ImageRepositoryError.noImageData {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation])
    }
    
    func test_API_호출이_실패한_경우_서버_ErrorAlertMessage를_담은_옵저버를_반환한다() throws {
        let expectation = XCTestExpectation(description: "test_fetch_imageData_API_failure")
        let urlString = "test_fail_API_URL"
        fetchImageUseCase = FetchImageUseCaseImpl(
            repository: MockAPIFailureImageRepository(
                cache: imageCache,
                storeAPI: storeAPI
            )
        )
        fetchImageUseCase.execute(url: urlString)
            .subscribe(onError: { error in
                if error as? ErrorAlertMessage == ErrorAlertMessage.server {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation])
    }
    
}
