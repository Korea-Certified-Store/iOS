//
//  ImageRepositoryImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 1/21/24.
//

import XCTest
@testable import KCS
import RxSwift
import RxTest
import RxBlocking
import Alamofire

final class ImageRepositoryImplTests: XCTestCase {

    var imageRepositoryImpl: ImageRepositoryImpl!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        ImageCache.shared.clearCache()
        imageRepositoryImpl = ImageRepositoryImpl()
        disposeBag = DisposeBag()
    }

    func test_캐시에_이미지가_존재하는_경우_캐시에서_이미지를_가져온다() {
        let urlString = UUID().uuidString
        guard let url = URL(string: urlString),
        let data = UUID().uuidString.data(using: .utf8) else {
            XCTFail("Data생성 실패")
            return
        }
        let imageData = NSData(data: data)
        ImageCache.shared.setImageData(imageData, for: url as NSURL)
        
        let observable = imageRepositoryImpl.fetchImage(url: urlString)
        
        XCTAssertEqual(data, try observable.toBlocking().first())
    }
    
    func test_빈_이미지를_받은_경우_noImageData에러_발생() {
        let urlString = UUID().uuidString
        guard let url = URL(string: urlString) else {
            XCTFail("URL 생성 실패")
            return
        }
        let imageData = NSData(data: Data())
        ImageCache.shared.setImageData(imageData, for: url as NSURL)
        
        let result = imageRepositoryImpl.fetchImage(url: urlString).toBlocking().materialize()
        do {
            switch result {
            case .completed(let elements):
                XCTFail("noImageData 에러가 발생해야 합니다.")
            case .failed(let elements, let error):
                XCTAssertTrue(elements.isEmpty)
                XCTAssertTrue(error is ImageRepositoryError)
            }
        }
    }
    
    func test_잘못된_URL인_경우_에러를_반환한다() {
        let wrongURL = "wrongURL"
        let result = imageRepositoryImpl.fetchImage(url: wrongURL).toBlocking().materialize()
        
        switch result {
        case .completed(let elements):
            XCTFail("잘못된 URL로 요청을 보내면 에러가 발생해야 합니다.")
        case .failed(let elements, let error):
            XCTAssertTrue(elements.isEmpty)
            XCTAssertTrue(error is AFError)
        }
    }

}
