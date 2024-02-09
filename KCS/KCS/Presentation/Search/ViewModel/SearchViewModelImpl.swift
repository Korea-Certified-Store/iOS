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
    let recentSearchKeywordsOutput = PublishRelay<[RecentSearchKeyword]>()
    
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
        case .viewWillAppear:
            viewWillAppear()
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
    
    func viewWillAppear() {
        fetchRecentSearchKeywordUseCase.execute()
            .bind { [weak self] keywords in
                self?.recentSearchKeywordsOutput.accept(keywords)
            }
            .disposed(by: disposeBag)
    }
    
    func textChanged(text: String) {
        if text.isEmpty {
            // TODO: recentHistory usecase 실행(debounce) 후 generateDataOutput.accept([])
        } else {
            // TODO: autoCompletion usecase 실행(debounce) 후 generateDataOutput.accept([])
        }
    }
    
    func searchButtonTapped(text: String) {
        saveRecentSearchKeywordUseCase.execute(
            recentSearchKeyword: RecentSearchKeyword(
                searchKeyword: text
            )
        )
    }
    
    func deleteSearchHistory(index: Int) {
        deleteRecentSearchKeywordUseCase.execute(index: index)
    }
    
}
