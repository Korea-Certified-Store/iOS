//
//  NewStoreRequestViewModelImplTests.swift
//  KCSUnitTest
//
//  Created by 김영현 on 3/4/24.
//

import XCTest
@testable import KCS
import Alamofire
import RxSwift
import RxTest

struct NewStoreRequestViewModelImplTestConstant {
    
    let dummyRepository = PostNewStoreRepositoryImpl(session: Session())
    let emptyTestText = ""
    let testText = "Test"
    let emptyCertificationSelected = RequestNewStoreCertificationIsSelected()
    let certificationSelected = RequestNewStoreCertificationIsSelected(goodPrice: true)
    
}

final class NewStoreRequestViewModelImplTests: XCTestCase {
    
    private var constant: NewStoreRequestViewModelImplTestConstant!
    private var postNewStoreUseCase: PostNewStoreUseCase!
    private var dependency: NewStoreRequestDependency!
    private var newStoreRequestViewModel: NewStoreRequestViewModelImpl!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        constant = NewStoreRequestViewModelImplTestConstant()
        postNewStoreUseCase = StubSuccessPostNewStoreUseCase(
            repository: constant.dummyRepository
        )
        dependency = NewStoreRequestDependency(
            postNewStoreUseCase: postNewStoreUseCase
        )
        newStoreRequestViewModel = NewStoreRequestViewModelImpl(
            dependency: dependency
        )
    }
    
    func test_제목_칸이_빈칸인_채로_수정을_마친_경우() {
        // Given
        let observer = scheduler.createObserver(Void.self)
        newStoreRequestViewModel.titleWarningOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .endEdit(text: constant.emptyTestText, inputCase: .title))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_제목_칸이_빈칸이_아닌채로_수정을_마친_경우() {
        // Given
        let observer = scheduler.createObserver(Void.self)
        newStoreRequestViewModel.titleEndEditOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .endEdit(text: constant.testText, inputCase: .title))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_주소_칸이_빈칸인_채로_수정을_마친_경우() {
        // Given
        let observer = scheduler.createObserver(Void.self)
        newStoreRequestViewModel.addressWarningOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .endEdit(text: constant.emptyTestText, inputCase: .address))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_주소_칸이_빈칸이_아닌채로_수정을_마친_경우() {
        // Given
        let observer = scheduler.createObserver(Void.self)
        newStoreRequestViewModel.addressEndEditOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .endEdit(text: constant.testText, inputCase: .address))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_상세_주소_칸이_빈칸인_채로_수정을_마친_경우() {
        // Given
        let observer = scheduler.createObserver(Void.self)
        newStoreRequestViewModel.detailAddressWarningOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .endEdit(
            text: constant.emptyTestText,
            inputCase: .detailAddress
        ))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_상세_주소_칸이_빈칸이_아닌채로_수정을_마친_경우() {
        // Given
        let observer = scheduler.createObserver(Void.self)
        newStoreRequestViewModel.detailAddressEndEditOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .endEdit(
            text: constant.testText,
            inputCase: .detailAddress
        ))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_인증제_버튼이_아무것도_활성화_되지_않은_경우() {
        // Given
        let observer = scheduler.createObserver(Void.self)
        newStoreRequestViewModel.certificationWarningOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .certificationEndEdit(
            requestNewStoreCertificationIsSelected: constant.emptyCertificationSelected
        ))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_인증제_버튼이_하나라도_활성화된_경우() {
        // Given
        let observer = scheduler.createObserver(Void.self)
        newStoreRequestViewModel.certificationEndEditOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .certificationEndEdit(
            requestNewStoreCertificationIsSelected: constant.certificationSelected
        ))
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_네비게이션바_상단_완료_버튼이_활성화_된_경우() {
        // Given
        let observer = scheduler.createObserver(Bool.self)
        newStoreRequestViewModel.completeButtonIsEnabledOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .whileEdit(text: constant.testText, inputCase: .title))
        newStoreRequestViewModel.action(input: .whileEdit(text: constant.testText, inputCase: .detailAddress))
        newStoreRequestViewModel.action(input: .endEdit(text: constant.testText, inputCase: .address))
        newStoreRequestViewModel.action(input: .certificationEndEdit(
            requestNewStoreCertificationIsSelected: constant.certificationSelected
        ))
        
        // Then
        XCTAssertEqual(observer.events.first?.value.element, true)
    }
    
    func test_제목란이_빈칸이기_때문에_네비게이션바_상단_완료_버튼이_활성화되지_않은_경우() {
        // Given
        let observer = scheduler.createObserver(Bool.self)
        newStoreRequestViewModel.completeButtonIsEnabledOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .whileEdit(text: constant.emptyTestText, inputCase: .title))
        newStoreRequestViewModel.action(input: .whileEdit(text: constant.testText, inputCase: .detailAddress))
        newStoreRequestViewModel.action(input: .endEdit(text: constant.testText, inputCase: .address))
        newStoreRequestViewModel.action(input: .certificationEndEdit(
            requestNewStoreCertificationIsSelected: constant.certificationSelected
        ))
        
        // Then
        XCTAssertEqual(observer.events.first?.value.element, false)
    }
    
    func test_주소란이_빈칸이기_때문에_네비게이션바_상단_완료_버튼이_활성화되지_않은_경우() {
        // Given
        let observer = scheduler.createObserver(Bool.self)
        newStoreRequestViewModel.completeButtonIsEnabledOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .whileEdit(text: constant.testText, inputCase: .title))
        newStoreRequestViewModel.action(input: .whileEdit(text: constant.testText, inputCase: .detailAddress))
        newStoreRequestViewModel.action(input: .endEdit(text: constant.emptyTestText, inputCase: .address))
        newStoreRequestViewModel.action(input: .certificationEndEdit(
            requestNewStoreCertificationIsSelected: constant.certificationSelected
        ))
        
        // Then
        XCTAssertEqual(observer.events.first?.value.element, false)
    }
    
    func test_상세주소란이_빈칸이기_때문에_네비게이션바_상단_완료_버튼이_활성화되지_않은_경우() {
        // Given
        let observer = scheduler.createObserver(Bool.self)
        newStoreRequestViewModel.completeButtonIsEnabledOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .whileEdit(text: constant.testText, inputCase: .title))
        newStoreRequestViewModel.action(input: .whileEdit(text: constant.emptyTestText, inputCase: .detailAddress))
        newStoreRequestViewModel.action(input: .endEdit(text: constant.testText, inputCase: .address))
        newStoreRequestViewModel.action(input: .certificationEndEdit(
            requestNewStoreCertificationIsSelected: constant.certificationSelected
        ))
        
        // Then
        XCTAssertEqual(observer.events.first?.value.element, false)
    }
    
    func test_활성화된_인증제_버튼이_없기_때문에_네비게이션바_상단_완료_버튼이_활성화되지_않은_경우() {
        // Given
        let observer = scheduler.createObserver(Bool.self)
        newStoreRequestViewModel.completeButtonIsEnabledOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(input: .whileEdit(text: constant.testText, inputCase: .title))
        newStoreRequestViewModel.action(input: .whileEdit(text: constant.emptyTestText, inputCase: .detailAddress))
        newStoreRequestViewModel.action(input: .endEdit(text: constant.testText, inputCase: .address))
        newStoreRequestViewModel.action(input: .certificationEndEdit(
            requestNewStoreCertificationIsSelected: constant.emptyCertificationSelected
        ))
        
        // Then
        XCTAssertEqual(observer.events.first?.value.element, false)
    }
    
    func test_완료버튼을_누르고_서버에_정상적으로_POST_된_경우() {
        // Given
        let observer = scheduler.createObserver(Void.self)
        newStoreRequestViewModel.completePostNewStoreOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(
            input: .completeButtonTapped(
                storeName: constant.testText,
                address: constant.testText,
                certifications: constant.certificationSelected
            )
        )
        
        // Then
        XCTAssertNotNil(observer.events.first)
    }
    
    func test_완료버튼을_누르고_서버_에러로_POST실패한_경우() {
        // Given
        postNewStoreUseCase = StubServerFailurePostNewStoreUseCase(
            repository: constant.dummyRepository
        )
        dependency = NewStoreRequestDependency(
            postNewStoreUseCase: postNewStoreUseCase
        )
        newStoreRequestViewModel = NewStoreRequestViewModelImpl(
            dependency: dependency
        )
        let observer = scheduler.createObserver(ErrorAlertMessage.self)
        newStoreRequestViewModel.errorAlertOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(
            input: .completeButtonTapped(
                storeName: constant.testText,
                address: constant.testText,
                certifications: constant.certificationSelected
            )
        )
        
        // Then
        XCTAssertEqual(observer.events.first?.value.element, ErrorAlertMessage.server)
    }
    
    func test_완료버튼을_누르고_알_수_없는_에러로_POST실패한_경우() {
        // Given
        postNewStoreUseCase = StubClientFailurePostNewStoreUseCase(
            repository: constant.dummyRepository
        )
        dependency = NewStoreRequestDependency(
            postNewStoreUseCase: postNewStoreUseCase
        )
        newStoreRequestViewModel = NewStoreRequestViewModelImpl(
            dependency: dependency
        )
        let observer = scheduler.createObserver(ErrorAlertMessage.self)
        newStoreRequestViewModel.errorAlertOutput
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        newStoreRequestViewModel.action(
            input: .completeButtonTapped(
                storeName: constant.testText,
                address: constant.testText,
                certifications: constant.certificationSelected
            )
        )
        
        // Then
        XCTAssertEqual(observer.events.first?.value.element, ErrorAlertMessage.client)
    }
    
}
