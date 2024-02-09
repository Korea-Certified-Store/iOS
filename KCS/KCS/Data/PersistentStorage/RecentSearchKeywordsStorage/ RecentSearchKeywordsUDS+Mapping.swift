//
//  RecentSearchKeywordsUDS+Mapping.swift
//  KCS
//
//  Created by 김영현 on 2/9/24.
//

import Foundation

struct RecentSearchKeywordsListUDS: Codable {
    var searchKeywordsList: [RecentSearchKeywordsUDS]
}

struct RecentSearchKeywordsUDS: Codable {
    let searchKeyword: String
    
    init(recentSearchKeyword: RecentSearchKeyword) {
        searchKeyword = recentSearchKeyword.searchKeyword
    }
}

extension RecentSearchKeywordsUDS {
    func toEntity() -> RecentSearchKeyword {
        return .init(searchKeyword: searchKeyword)
    }
}
