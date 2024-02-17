//
//  AutoCompletionTableViewCell.swift
//  KCS
//
//  Created by 조성민 on 2/12/24.
//

import UIKit

final class AutoCompletionTableViewCell: UITableViewCell {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = SystemImage.search?.withTintColor(
            .kcsGray1,
            renderingMode: .alwaysOriginal
        )

        return imageView
    }()
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .pretendard(size: 16, weight: .medium)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIContents(keyword: String) {
        keywordLabel.text = keyword
    }
    
}

private extension AutoCompletionTableViewCell {
    
    func addUIComponents() {
        addSubview(iconImageView)
        addSubview(keywordLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            keywordLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            keywordLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            keywordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
}
