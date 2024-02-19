//
//  SearchViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 2/8/24.
//

import RxSwift
import RxRelay

final class SearchViewModelImpl: SearchViewModel {
    
    let dependency: SearchDependency
    
    let recentSearchKeywordsOutput = PublishRelay<[String]>()
    let autoCompleteKeywordsOutput = PublishRelay<[String]>()
    let changeTextColorOutput = PublishRelay<String>()
    let searchOutput = PublishRelay<String>()
    let noKeywordToastOutput = PublishRelay<Void>()
    let noRecentHistoryOutput = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    init(dependency: SearchDependency) {
        self.dependency = dependency
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
            dependency.getAutoCompletionUseCase.execute(keyword: text)
                .bind { [weak self] keywords in
                    self?.autoCompleteKeywordsOutput.accept(keywords)
                    self?.changeTextColorOutput.accept(text)
                }
                .disposed(by: disposeBag)
        }
    }
     
    func searchButtonTapped(text: String) {
        dependency.saveRecentSearchKeywordUseCase.execute(
            recentSearchKeyword: text
        )
    }
    
    func deleteSearchHistory(index: Int) {
        dependency.deleteRecentSearchKeywordUseCase.execute(index: index)
        emitRecentHistory()
    }
    
    func deleteAllHistory() {
        dependency.deleteAllHistoryUseCase.execute()
        emitRecentHistory()
    }
    
    func emitRecentHistory() {
        dependency.fetchRecentSearchKeywordUseCase.execute()
            .bind { [weak self] keywords in
                self?.recentSearchKeywordsOutput.accept(keywords)
                if keywords.isEmpty {
                    self?.noRecentHistoryOutput.accept(())
                }
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
