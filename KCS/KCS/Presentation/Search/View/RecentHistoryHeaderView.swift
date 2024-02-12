//
//  RecentHistoryHeaderView.swift
//  KCS
//
//  Created by 조성민 on 2/12/24.
//

import UIKit
import RxRelay
import RxSwift

// TODO: 전체삭제 기능 구현
final class RecentHistoryHeaderView: UITableViewHeaderFooterView {
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "최근 검색어"
        label.font = UIFont.pretendard(size: 17, weight: .semibold)
        
        return label
    }()
    
    private lazy var clearAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var attributedTitle = AttributedString("전체삭제")
        attributedTitle.font = UIFont.pretendard(size: 12, weight: .medium)
        
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .placeholderText
        config.attributedTitle = attributedTitle
        button.configuration = config
        
        return button
    }()
    
    private let divideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .kcsGray3
        
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addUIComponents()
        configureConstraints()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension RecentHistoryHeaderView {
    
    func addUIComponents() {
        addSubview(titleLabel)
        addSubview(clearAllButton)
        addSubview(divideView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clearAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            clearAllButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divideView.heightAnchor.constraint(equalToConstant: 1),
            divideView.leadingAnchor.constraint(equalTo: leadingAnchor),
            divideView.trailingAnchor.constraint(equalTo: trailingAnchor),
            divideView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setup() {
        backgroundColor = .white
    }
    
}