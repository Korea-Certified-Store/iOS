//
//  SummaryViewModelImpl.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import RxSwift
import RxRelay

final class SummaryViewModelImpl: SummaryViewModel {
    
    private let disposeBag = DisposeBag()
    
    let getOpenClosedUseCase: GetOpenClosedUseCase
    let fetchImageUseCase: FetchImageUseCase
    
    var setUIContentsOutput = PublishRelay<SummaryViewContents>()
    var thumbnailImageOutput = PublishRelay<Data>()
    var callButtonOutput = PublishRelay<String>()
    
    init(getOpenClosedUseCase: GetOpenClosedUseCase, fetchImageUseCase: FetchImageUseCase) {
        self.getOpenClosedUseCase = getOpenClosedUseCase
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    func action(input: SummaryViewInputCase) {
        switch input {
        case .setUIContents(store: let store):
            setUIContents(store: store)
        }
    }
    
}

private extension SummaryViewModelImpl {
    
    func setUIContents(store: Store) {
        do {
            let openClosedContent = try getOpenClosedUseCase.execute(openingHours: store.openingHour)
            
            fetchThumbnailImage(localPhotos: store.localPhotos)
            if let phoneNumber = store.phoneNumber {
                callButtonOutput.accept(phoneNumber)
            }
            
            setUIContentsOutput.accept(
                SummaryViewContents(
                    storeTitle: store.title,
                    category: store.category,
                    certificationTypes: store.certificationTypes,
                    openClosedContent: openClosedContent
                )
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchThumbnailImage(localPhotos: [String]) {
        guard let url = localPhotos.first else { return }
        fetchImageUseCase.execute(url: url)
            .subscribe(
                onNext: { [weak self] imageData in
                    self?.thumbnailImageOutput.accept(imageData)
                },
                onError: { error in
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
}
