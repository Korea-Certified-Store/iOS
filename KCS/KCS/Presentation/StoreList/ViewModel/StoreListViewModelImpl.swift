//
//  StoreListViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 1/31/24.
//

import RxRelay
import RxSwift

final class StoreListViewModelImpl: StoreListViewModel {
    
    var fetchImageUseCase: FetchImageUseCase
    
    var updateListOutput = BehaviorRelay<[StoreTableViewCellContents]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    init(fetchImageUseCase: FetchImageUseCase) {
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    func action(input: StoreListViewModelInputCase) {
        switch input {
        case .updateList(let stores):
            updateList(stores: stores)
        }
    }
    
}

private extension StoreListViewModelImpl {
    
    func updateList(stores: [Store]) {
        Observable.zip(stores.map({ [weak self] store in
            guard let self = self,
                  let url = store.localPhotos.first else { return Observable<Data?>.just(nil) }
            
            return fetchImageUseCase.execute(url: url)
                .flatMap { Observable<Data?>.just($0) }
        }))
        .bind { [weak self] imageDataArray in
            var storeContentsArray: [StoreTableViewCellContents] = []
            for index in stores.indices {
                let store = stores[index]
                storeContentsArray.append(
                    StoreTableViewCellContents(
                        storeTitle: store.title,
                        category: store.category,
                        certificationTypes: store.certificationTypes,
                        thumbnailImageData: imageDataArray[index]
                    )
                )
            }
            self?.updateListOutput.accept(storeContentsArray)
        }
        .disposed(by: disposeBag)
    }
    
}
