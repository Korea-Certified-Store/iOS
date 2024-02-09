//
//  SearchViewModelImpl.swift
//  KCS
//
//  Created by 조성민 on 2/8/24.
//

import RxRelay

final class SearchViewModelImpl: SearchViewModel {
    
    var generateDataOutput = PublishRelay<[String]>()
    
    func action(input: SearchViewModelInputCase) {
        switch input {
        case .textChanged(let text):
            textChanged(text: text)
        }
    }
    
}

private extension SearchViewModelImpl {
    
    func textChanged(text: String) {
        if text.isEmpty {
            // TODO: recentHistory usecase 실행(debounce) 후 generateDataOutput.accept([])
        } else {
            // TODO: autoCompletion usecase 실행(debounce) 후 generateDataOutput.accept([])
        }
    }
    
}
