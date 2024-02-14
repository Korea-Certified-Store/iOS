//
//  SearchViewModel.swift
//  KCS
//
//  Created by 조성민 on 2/8/24.
//

import RxRelay

protocol SearchViewModel: SearchViewModelInput, SearchViewModelOutput {
    
    var fetchRecentSearchKeywordUseCase: FetchRecentSearchKeywordUseCase { get }
    var saveRecentSearchKeywordUseCase: SaveRecentSearchKeywordUseCase { get }
    var deleteRecentSearchKeywordUseCase: DeleteRecentSearchKeywordUseCase { get }
    var deleteAllHistoryUseCase: DeleteAllHistoryUseCase { get }
    
}

protocol SearchViewModelInput {
    
    func action(input: SearchViewModelInputCase)
    
}

enum SearchViewModelInputCase {
    
    case textChanged(text: String)
    case searchButtonTapped(text: String)
    case deleteSearchHistory(index: Int)
    case deleteAllHistory
    case returnKeyTapped(text: String)
    
}

protocol SearchViewModelOutput {
    
    var recentSearchKeywordsOutput: PublishRelay<[String]> { get }
    var autoCompleteKeywordsOutput: PublishRelay<[String]> { get }
    var searchOutput: PublishRelay<String> { get }
    
}
