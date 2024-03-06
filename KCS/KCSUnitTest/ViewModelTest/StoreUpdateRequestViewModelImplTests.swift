//
//  StoreUpdateRequestViewModelImplTests.swift
//  KCSUnitTest
//
//  Created by 조성민 on 3/5/24.
//

import XCTest
@testable import KCS
import RxSwift
import RxTest

struct StoreUpdateRequestViewModelImplTestsConstant {
    
    static let fetchStoreIDUseCaseResult: Int = 3
    let dummyStoreID: Int = 1234
    let spySetStoreIDUseCaseExecuteCountResult: Int = 1
    let emptyString: String = ""
    let typeFixString: String = "수정"
    let typeDeleteString: String = "삭제"
    let contentInputNormalString: String = "abc"
    let contentInputOverLengthString: String = String.init(repeating: "a", count: 301)
    
}

// action의 종류 : 6개

final class StoreUpdateRequestViewModelImplTests: XCTestCase {

    private var storeUpdateRequestViewModel: StoreUpdateRequestViewModelImpl!
    private var stubSuccessStoreUpdateRequestUseCase: StubSuccessStoreUpdateRequestUseCase!
    private var stubInternetFailureStoreUpdateRequestUseCase: StubInternetFailureStoreUpdateRequestUseCase!
    private var stubServerFailureStoreUpdateRequestUseCase: StubServerFailureStoreUpdateRequestUseCase!
    private var stubClientFailureStoreUpdateRequestUseCase: StubClientFailureStoreUpdateRequestUseCase!
    private var stubSuccessFetchStoreIDUseCase: StubSuccessFetchStoreIDUseCase!
    private var stubFailureFetchStoreIDUseCase: StubFailureFetchStoreIDUseCase!
    private var spySetStoreIDUseCase: SpySetStoreIDUseCase!
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var dependency: StoreUpdateRequestDepenency!
    private var constant: StoreUpdateRequestViewModelImplTestsConstant!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        constant = StoreUpdateRequestViewModelImplTestsConstant()
        stubSuccessStoreUpdateRequestUseCase = StubSuccessStoreUpdateRequestUseCase()
        stubInternetFailureStoreUpdateRequestUseCase = StubInternetFailureStoreUpdateRequestUseCase()
        stubServerFailureStoreUpdateRequestUseCase = StubServerFailureStoreUpdateRequestUseCase()
        stubClientFailureStoreUpdateRequestUseCase = StubClientFailureStoreUpdateRequestUseCase()
        stubSuccessFetchStoreIDUseCase = StubSuccessFetchStoreIDUseCase()
        stubFailureFetchStoreIDUseCase = StubFailureFetchStoreIDUseCase()
        spySetStoreIDUseCase = SpySetStoreIDUseCase()
    }
    
    func test_setStoreID_호출_성공() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        
        // When
        storeUpdateRequestViewModel.action(input: .setStoreID(id: constant.dummyStoreID))
        
        // Then
        XCTAssertEqual(spySetStoreIDUseCase.executeCount, constant.spySetStoreIDUseCaseExecuteCountResult)
    }
    
    func test_typeInput_비어있는_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let observer = scheduler.createObserver(Void.self)
        
        storeUpdateRequestViewModel.typeWarningOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .typeInput(text: constant.emptyString))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_typeInput_수정을_선택한_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let observer = scheduler.createObserver(Void.self)
        
        storeUpdateRequestViewModel.typeEditEndOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .typeInput(text: constant.typeFixString))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_typeInput_삭제를_선택한_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let observer = scheduler.createObserver(Void.self)
        
        storeUpdateRequestViewModel.typeEditEndOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .typeInput(text: constant.typeDeleteString))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_contentEndEditing_content가_비어있는_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let contentWarningObserver = scheduler.createObserver(Void.self)
        let contentLengthWarningObserver = scheduler.createObserver(Void.self)
        
        storeUpdateRequestViewModel.contentWarningOutput
            .subscribe(contentWarningObserver)
            .disposed(by: disposeBag)
        storeUpdateRequestViewModel.contentLengthWarningOutput
            .subscribe(contentLengthWarningObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .contentEndEditing(text: constant.emptyString))
        
        // Then
        XCTAssertNotNil(contentWarningObserver.events.first)
        XCTAssertNotNil(contentLengthWarningObserver.events.first)
    }
    
    func test_contentEndEditing_content길이가_1이상_300이하인_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let contentEditEndObserver = scheduler.createObserver(Void.self)
        let contentLengthNormalObserver = scheduler.createObserver(Void.self)
        
        storeUpdateRequestViewModel.contentEditEndOutput
            .subscribe(contentEditEndObserver)
            .disposed(by: disposeBag)
        storeUpdateRequestViewModel.contentLengthNormalOutput
            .subscribe(contentLengthNormalObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .contentEndEditing(text: constant.contentInputNormalString))
        
        // Then
        XCTAssertNotNil(contentEditEndObserver.events.first)
        XCTAssertNotNil(contentLengthNormalObserver.events.first)
    }
    
    func test_contentEndEditing_content길이가_300초과인_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let contentWarningObserver = scheduler.createObserver(Void.self)
        let contentLengthWarningObserver = scheduler.createObserver(Void.self)
        
        storeUpdateRequestViewModel.contentWarningOutput
            .subscribe(contentWarningObserver)
            .disposed(by: disposeBag)
        storeUpdateRequestViewModel.contentLengthWarningOutput
            .subscribe(contentLengthWarningObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .contentEndEditing(text: constant.contentInputOverLengthString))
        
        // Then
        XCTAssertNotNil(contentWarningObserver.events.first)
        XCTAssertNotNil(contentLengthWarningObserver.events.first)
    }
    
    func test_contentWhileEditing_content가_비어있는_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let contentFillPlaceHolderObserver = scheduler.createObserver(Void.self)
        let contentLengthWarningObserver = scheduler.createObserver(Void.self)
        
        storeUpdateRequestViewModel.contentFillPlaceHolder
            .subscribe(contentFillPlaceHolderObserver)
            .disposed(by: disposeBag)
        storeUpdateRequestViewModel.contentLengthWarningOutput
            .subscribe(contentLengthWarningObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .contentWhileEditing(text: constant.emptyString))
        
        // Then
        XCTAssertNotNil(contentFillPlaceHolderObserver.events.first)
        XCTAssertNotNil(contentLengthWarningObserver.events.first)
    }
    
    func test_contentWhileEditing_content길이가_1이상_300이하인_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let contentErasePlaceHolderObserver = scheduler.createObserver(Void.self)
        let contentLengthNormalOutputObserver = scheduler.createObserver(Void.self)
        
        storeUpdateRequestViewModel.contentErasePlaceHolder
            .subscribe(contentErasePlaceHolderObserver)
            .disposed(by: disposeBag)
        storeUpdateRequestViewModel.contentLengthNormalOutput
            .subscribe(contentLengthNormalOutputObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .contentWhileEditing(text: constant.contentInputNormalString))
        
        // Then
        XCTAssertNotNil(contentErasePlaceHolderObserver.events.first)
        XCTAssertNotNil(contentLengthNormalOutputObserver.events.first)
    }
    
    func test_contentWhileEditing_content길이가_300초과인_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let contentErasePlaceHolderObserver = scheduler.createObserver(Void.self)
        let contentLengthWarningObserver = scheduler.createObserver(Void.self)
        
        storeUpdateRequestViewModel.contentErasePlaceHolder
            .subscribe(contentErasePlaceHolderObserver)
            .disposed(by: disposeBag)
        storeUpdateRequestViewModel.contentLengthWarningOutput
            .subscribe(contentLengthWarningObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .contentWhileEditing(text: constant.contentInputOverLengthString))
        
        // Then
        XCTAssertNotNil(contentErasePlaceHolderObserver.events.first)
        XCTAssertNotNil(contentLengthWarningObserver.events.first)
    }
    
    func test_completeButtonIsEnable_type이_비어있는_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let completeButtonIsEnabledObserver = scheduler.createObserver(Bool.self)
        
        storeUpdateRequestViewModel.completeButtonIsEnabledOutput
            .subscribe(completeButtonIsEnabledObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .completeButtonIsEnable(type: constant.emptyString, content: constant.contentInputNormalString))
        
        // Then
        XCTAssertEqual(completeButtonIsEnabledObserver.events.first?.value.element, false)
    }
    
    func test_completeButtonIsEnable_content가_비어있는_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let completeButtonIsEnabledObserver = scheduler.createObserver(Bool.self)
        
        storeUpdateRequestViewModel.completeButtonIsEnabledOutput
            .subscribe(completeButtonIsEnabledObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .completeButtonIsEnable(type: constant.typeFixString, content: constant.emptyString))
        
        // Then
        XCTAssertEqual(completeButtonIsEnabledObserver.events.first?.value.element, false)
    }
    
    func test_completeButtonIsEnable_content_길이가_300초과인_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let completeButtonIsEnabledObserver = scheduler.createObserver(Bool.self)
        
        storeUpdateRequestViewModel.completeButtonIsEnabledOutput
            .subscribe(completeButtonIsEnabledObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .completeButtonIsEnable(type: constant.typeFixString, content: constant.contentInputOverLengthString))
        
        // Then
        XCTAssertEqual(completeButtonIsEnabledObserver.events.first?.value.element, false)
    }
    
    func test_completeButtonIsEnable_type이_있으며_content길이가_1이상_300이하인_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let completeButtonIsEnabledObserver = scheduler.createObserver(Bool.self)
        
        storeUpdateRequestViewModel.completeButtonIsEnabledOutput
            .subscribe(completeButtonIsEnabledObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .completeButtonIsEnable(type: constant.typeFixString, content: constant.contentInputNormalString))
        
        // Then
        XCTAssertEqual(completeButtonIsEnabledObserver.events.first?.value.element, true)
    }
    
    func test_storeUpdateRequest_fetchStoreID_실패한_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubFailureFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let errorAlertObserver = scheduler.createObserver(ErrorAlertMessage.self)
        
        storeUpdateRequestViewModel.errorAlertOutput
            .subscribe(errorAlertObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .storeUpdateRequest(type: constant.typeFixString, content: constant.contentInputNormalString))
        
        // Then
        XCTAssertEqual(errorAlertObserver.events.first?.value.element, .client)
    }
    
    func test_storeUpdateRequest_fetchStoreID_성공후_storeUpdateRequest_Internet_에러로_실패한_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubInternetFailureStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let errorAlertObserver = scheduler.createObserver(ErrorAlertMessage.self)
        
        storeUpdateRequestViewModel.errorAlertOutput
            .subscribe(errorAlertObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .storeUpdateRequest(type: constant.typeFixString, content: constant.contentInputNormalString))
        
        // Then
        XCTAssertEqual(errorAlertObserver.events.first?.value.element, .internet)
    }
    
    func test_storeUpdateRequest_fetchStoreID_성공후_storeUpdateRequest_Server_에러로_실패한_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubServerFailureStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let errorAlertObserver = scheduler.createObserver(ErrorAlertMessage.self)
        
        storeUpdateRequestViewModel.errorAlertOutput
            .subscribe(errorAlertObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .storeUpdateRequest(type: constant.typeFixString, content: constant.contentInputNormalString))
        
        // Then
        XCTAssertEqual(errorAlertObserver.events.first?.value.element, .server)
    }
    
    func test_storeUpdateRequest_fetchStoreID_성공후_storeUpdateRequest_Client_에러로_실패한_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubClientFailureStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let errorAlertObserver = scheduler.createObserver(ErrorAlertMessage.self)
        
        storeUpdateRequestViewModel.errorAlertOutput
            .subscribe(errorAlertObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .storeUpdateRequest(type: constant.typeFixString, content: constant.contentInputNormalString))
        
        // Then
        XCTAssertEqual(errorAlertObserver.events.first?.value.element, .client)
    }
    
    func test_storeUpdateRequest_fetchStoreID_성공후_storeUpdateRequest_성공한_경우() {
        // Given
        dependency = StoreUpdateRequestDepenency(
            storeUpdateRequestUseCase: stubSuccessStoreUpdateRequestUseCase,
            fetchStoreIDUseCase: stubSuccessFetchStoreIDUseCase,
            setStoreIDUseCase: spySetStoreIDUseCase
        )
        storeUpdateRequestViewModel = StoreUpdateRequestViewModelImpl(dependency: dependency)
        let completeRequestObserver = scheduler.createObserver(Void.self)
        
        storeUpdateRequestViewModel.completeRequestOutput
            .subscribe(completeRequestObserver)
            .disposed(by: disposeBag)
        
        // When
        storeUpdateRequestViewModel.action(input: .storeUpdateRequest(type: constant.typeFixString, content: constant.contentInputNormalString))
        
        // Then
        XCTAssertNotNil(completeRequestObserver.events.first)
    }
    
}
