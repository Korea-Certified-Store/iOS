//
//  StoreTableViewCell.swift
//  KCS
//
//  Created by 조성민 on 1/31/24.
//

import UIKit

final class StoreTableViewCell: UITableViewCell {

    private lazy var storeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 20, weight: .bold)
        label.textColor = UIColor.primary1
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var certificationStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillProportionally
        
        return stack
    }()
    
    private lazy var category: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 11, weight: .regular)
        label.textColor = UIColor.grayLabel
        
        return label
    }()
    
    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setLayerCorner(cornerRadius: 4)
        imageView.clipsToBounds = true
        imageView.image = UIImage.basicStore
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addUIContents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        storeTitle.text = nil
        certificationStackView.clear()
        category.text = nil
        storeImageView.image = .basicStore
    }
    
    func setUIContents(store: Store) {
        
    }
    
}

private extension StoreTableViewCell {
    
    func addUIContents() {
        contentView.addSubview(storeTitle)
        contentView.addSubview(certificationStackView)
        contentView.addSubview(category)
        contentView.addSubview(storeImageView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            storeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            storeImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            storeImageView.widthAnchor.constraint(equalToConstant: 77),
            storeImageView.heightAnchor.constraint(equalToConstant: 77)
        ])
        
        NSLayoutConstraint.activate([
            storeTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            storeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storeTitle.trailingAnchor.constraint(equalTo: storeImageView.leadingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            category.topAnchor.constraint(equalTo: storeTitle.bottomAnchor, constant: 8),
            category.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            certificationStackView.topAnchor.constraint(equalTo: category.bottomAnchor, constant: 11),
            certificationStackView.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
    }
    
}
