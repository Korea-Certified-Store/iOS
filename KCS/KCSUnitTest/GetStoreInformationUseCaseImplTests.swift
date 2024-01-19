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
    var disposeBag: DisposeBag!
    
    override func setUp() {
        disposeBag = DisposeBag()
    }
    
    func test_있는_tag를_찾는_경우_execute의_결과는_에러가_없고_tag가_같은_Store_객체() {
        let tag: UInt = 1
        let store = Store(
            id: Int(tag),
            title: "",
            certificationTypes: [],
            category: "",
            address: "",
            phoneNumber: "",
            location: Location(longitude: 0, latitude: 0),
            openingHour: [],
            localPhotos: []
        )
        getStoreInformationUseCase = GetStoreInformationUseCaseImpl(
            repository: StoreRepositoryImpl(stores: [store])
        )
        
        XCTAssertNoThrow(try getStoreInformationUseCase.execute(tag: tag))
        XCTAssertEqual(try getStoreInformationUseCase.execute(tag: tag), store)
    }
    
    func test_없는_tag를_찾는_경우_execute의_결과는_에러_발생() {
        let tag: UInt = 1
        let otherTag: UInt = 3
        let store = Store(
            id: Int(tag),
            title: "",
            certificationTypes: [],
            category: "",
            address: "",
            phoneNumber: "",
            location: Location(longitude: 0, latitude: 0),
            openingHour: [],
            localPhotos: []
        )
        getStoreInformationUseCase = GetStoreInformationUseCaseImpl(
            repository: StoreRepositoryImpl(stores: [store])
        )
        
        XCTAssertThrowsError(try getStoreInformationUseCase.execute(tag: otherTag), "없는 테그를 찾는 경우 error 발생 성공")
    }
    
    func test_비어있는_Repository에서_찾는_경우_execute의_결과는_에러_발생() {
        let tag: UInt = 1
        getStoreInformationUseCase = GetStoreInformationUseCaseImpl(
            repository: StoreRepositoryImpl(stores: [])
        )
        
        XCTAssertThrowsError(try getStoreInformationUseCase.execute(tag: tag), "비어있는 Repository에서 찾는 경우 error 발생 성공")
    }
    
}
