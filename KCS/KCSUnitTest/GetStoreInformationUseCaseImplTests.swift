//
//  GetStoreInformationUseCaseImplTests.swift
//  GetStoreInformationUseCaseImplTests
//
//  Created by 조성민 on 1/18/24.
//

import XCTest
@testable import KCS
import RxSwift
import RxTest
import RxBlocking
import Alamofire

final class GetStoreInformationUseCaseImplTests: XCTestCase {
    
    var getStoreInformationUseCase: GetStoreInformationUseCaseImpl!
    var successRepository: MockSuccessStoreRepository!
    var failRepository: MockFailStoreRepository!
    var disposeBag: DisposeBag!
    var tag: UInt!
    
    override func setUp() {
        disposeBag = DisposeBag()
        tag = 8
        successRepository = MockSuccessStoreRepository(targetTag: Int(tag))
        failRepository = MockFailStoreRepository()
    }
    
    func test_있는_tag를_찾는_경우_execute의_결과는_에러가_없고_tag가_같은_Store_객체() {
        getStoreInformationUseCase = GetStoreInformationUseCaseImpl(repository: successRepository)
        XCTAssertNoThrow(try getStoreInformationUseCase.execute(tag: tag))
        XCTAssertEqual(try getStoreInformationUseCase.execute(tag: tag), successRepository.getTargetStore())
    }
    
    func test_없는_tag를_찾는_경우_execute의_결과는_에러_발생() {
        getStoreInformationUseCase = GetStoreInformationUseCaseImpl(repository: failRepository)
        let otherTag: UInt = tag + 1
        
        XCTAssertThrowsError(try getStoreInformationUseCase.execute(tag: otherTag), "없는 Tag를 찾는 경우 error 발생 성공")
    }
    
}
