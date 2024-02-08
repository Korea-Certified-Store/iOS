//
//  SearchWordView.swift
//  KCS
//
//  Created by 조성민 on 2/9/24.
//

import UIKit

final class SearchWordView: UIView {
    
    private let searchingKeywordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    func setSearchKeyword(keyword: String) {
        searchingKeywordLabel.text = keyword
    }
    
    func getSearchKeyword() -> String? {
        return searchingKeywordLabel.text
    }
    
    init() {
        super.init(frame: .zero)
        
        addUIComponents()
        configureConstraints()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SearchWordView {
    
    func setup() {
        backgroundColor = .white
    }
    
    func addUIComponents() {
        addSubview(searchingKeywordLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            searchingKeywordLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchingKeywordLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}
