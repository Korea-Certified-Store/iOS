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
    var deleteAllHistoryUseCase: DeleteAllHistoryUseCase
    var getAutoCompletionUseCase: GetAutoCompletionUseCase
    
    let recentSearchKeywordsOutput = PublishRelay<[String]>()
    let autoCompleteKeywordsOutput = PublishRelay<[String]>()
    let searchOutput = PublishRelay<String>()
    let noKeywordToastOutput = PublishRelay<Void>()
    
    init(
        fetchRecentSearchKeywordUseCase: FetchRecentSearchKeywordUseCase,
        saveRecentSearchKeywordUseCase: SaveRecentSearchKeywordUseCase,
        deleteRecentSearchKeywordUseCase: DeleteRecentSearchKeywordUseCase,
        deleteAllHistoryUseCase: DeleteAllHistoryUseCase,
        getAutoCompletionUseCase: GetAutoCompletionUseCase
    ) {
        self.fetchRecentSearchKeywordUseCase = fetchRecentSearchKeywordUseCase
        self.saveRecentSearchKeywordUseCase = saveRecentSearchKeywordUseCase
        self.deleteRecentSearchKeywordUseCase = deleteRecentSearchKeywordUseCase
        self.deleteAllHistoryUseCase = deleteAllHistoryUseCase
        self.getAutoCompletionUseCase = getAutoCompletionUseCase
    }
    
    func action(input: SearchViewModelInputCase) {
        switch input {
        case .textChanged(let text):
            textChanged(text: text)
        case .searchButtonTapped(let text):
            searchButtonTapped(text: text)
        case .deleteSearchHistory(let index):
            deleteSearchHistory(index: index)
        case .deleteAllHistory:
            deleteAllHistory()
        case .returnKeyTapped(let text):
            returnKeyTapped(text: text)
        }
    }
    
}

private extension SearchViewModelImpl {
    
    func textChanged(text: String) {
        if text.isEmpty {
            emitRecentHistory()
        } else {
            getAutoCompletionUseCase.execute(keyword: text)
                .bind { [weak self] keywords in
                    self?.autoCompleteKeywordsOutput.accept(keywords)
                }
                .disposed(by: disposeBag)
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
    
    func deleteAllHistory() {
        deleteAllHistoryUseCase.execute()
        emitRecentHistory()
    }
    
    func emitRecentHistory() {
        fetchRecentSearchKeywordUseCase.execute()
            .bind { [weak self] keywords in
                self?.recentSearchKeywordsOutput.accept(keywords)
            }
            .disposed(by: disposeBag)
    }
    
    func returnKeyTapped(text: String) {
        if !text.trimmingCharacters(in: .whitespaces).isEmpty {
            searchOutput.accept(text)
        } else {
            noKeywordToastOutput.accept(())
        }
    }
    
}
