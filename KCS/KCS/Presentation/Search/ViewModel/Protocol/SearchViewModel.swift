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
    
}

protocol SearchViewModelInput {
    
    func action(input: SearchViewModelInputCase)
    
}

enum SearchViewModelInputCase {
    
    case textChanged(text: String)
    case searchButtonTapped(text: String)
    case deleteSearchHistory(index: Int)
    
}

protocol SearchViewModelOutput {
    
    var generateDataOutput: PublishRelay<[String]> { get }
    var recentSearchKeywordsOutput: PublishRelay<[String]> { get }
    var autoCompleteKeywordsOutput: PublishRelay<[String]> { get }
    
}
