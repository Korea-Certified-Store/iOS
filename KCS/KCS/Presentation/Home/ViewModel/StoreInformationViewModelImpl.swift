//
//  StoreInformationViewModelImpl.swift
//  KCS
//
//  Created by 김영현 on 1/18/24.
//

import RxSwift
import RxRelay

final class StoreInformationViewModelImpl: SummaryInformationViewModel {
    
    private let disposeBag = DisposeBag()
    
    let getOpenClosedUseCase: GetOpenClosedUseCase
    let fetchImageUseCase: FetchImageUseCase
    
    var openClosedOutput = PublishRelay<OpenClosedContent>()
    var thumbnailImageOutput = PublishRelay<Data>()
    
    init(getOpenClosedUseCase: GetOpenClosedUseCase, fetchImageUseCase: FetchImageUseCase) {
        self.getOpenClosedUseCase = getOpenClosedUseCase
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    func action(input: StoreInformationViewInputCase) {
        switch input {
        case .setInformationView(let openingHour, let url):
            setOpenClosed(openingHour: openingHour)
            if let url = url {
                fetchThumbnailImage(url: url)
            }
        }
    }
    
}

private extension StoreInformationViewModelImpl {
    
    func setOpenClosed(
        openingHour: [RegularOpeningHours]
    ) {
        openClosedOutput.accept(getOpenClosedUseCase.execute(openingHours: openingHour))
    }
    
    func fetchThumbnailImage(url: String) {
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
