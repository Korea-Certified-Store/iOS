//
//  RecentHistoryHeaderView.swift
//  KCS
//
//  Created by 조성민 on 2/12/24.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa

final class RecentHistoryHeaderView: UITableViewHeaderFooterView {
    
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
        button.rx.tap
            .bind { [weak self] in
                self?.delegate?.clearAllButtonButtonTapped()
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private let divideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .kcsGray3
        
        return view
    }()
    
    private let disposeBag = DisposeBag()
    var delegate: RecentHistoryHeaderViewDelegate?
    
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(clearAllButton)
        contentView.addSubview(divideView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clearAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            clearAllButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divideView.heightAnchor.constraint(equalToConstant: 1),
            divideView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divideView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divideView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setup() {
        contentView.backgroundColor = .white
    }
    
}
