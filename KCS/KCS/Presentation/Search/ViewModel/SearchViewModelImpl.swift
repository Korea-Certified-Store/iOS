//
//  SearchViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 2/8/24.
//

import RxSwift
import RxRelay

final class SearchViewModelImpl: SearchViewModel {
    
    let disposeBag = DisposeBag()
    
    var fetchRecentSearchKeywordUseCase: FetchRecentSearchKeywordUseCase
    var saveRecentSearchKeywordUseCase: SaveRecentSearchKeywordUseCase
    var deleteRecentSearchKeywordUseCase: DeleteRecentSearchKeywordUseCase
    
    let generateDataOutput = PublishRelay<[String]>()
    let recentSearchKeywordsOutput = PublishRelay<[String]>()
    let autoCompleteKeywordsOutput = PublishRelay<[String]>()
    
    init(
        fetchRecentSearchKeywordUseCase: FetchRecentSearchKeywordUseCase,
        saveRecentSearchKeywordUseCase: SaveRecentSearchKeywordUseCase,
        deleteRecentSearchKeywordUseCase: DeleteRecentSearchKeywordUseCase
    ) {
        self.fetchRecentSearchKeywordUseCase = fetchRecentSearchKeywordUseCase
        self.saveRecentSearchKeywordUseCase = saveRecentSearchKeywordUseCase
        self.deleteRecentSearchKeywordUseCase = deleteRecentSearchKeywordUseCase
    }
    
    func action(input: SearchViewModelInputCase) {
        switch input {
        case .textChanged(let text):
            textChanged(text: text)
        case .searchButtonTapped(let text):
            searchButtonTapped(text: text)
        case .deleteSearchHistory(let index):
            deleteSearchHistory(index: index)
        }
    }
    
}

private extension SearchViewModelImpl {
    
    func textChanged(text: String) {
        if text.isEmpty {
            emitRecentHistory()
        } else {
            // TODO: autoCompletion usecase 실행(debounce) 후 generateDataOutput.accept([]) (자동완성으로 전환)
            autoCompleteKeywordsOutput.accept([text])
        }
    }
     
    func searchButtonTapped(text: String) {
        saveRecentSearchKeywordUseCase.execute(
            recentSearchKeyword: text
        )
    }
    
    func deleteSearchHistory(index: Int) {
        deleteRecentSearchKeywordUseCase.execute(index: index)
        emitRecentHistory()
    }
    
    func emitRecentHistory() {
        fetchRecentSearchKeywordUseCase.execute()
            .bind { [weak self] keywords in
                self?.recentSearchKeywordsOutput.accept(keywords)
            }
            .disposed(by: disposeBag)
    }
    
}
