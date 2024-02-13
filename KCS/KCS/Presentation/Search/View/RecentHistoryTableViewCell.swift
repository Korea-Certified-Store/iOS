//
//  RecentHistoryTableViewCell.swift
//  KCS
//
//  Created by 조성민 on 2/12/24.
//

import UIKit
import RxSwift
import RxCocoa

final class RecentHistoryTableViewCell: UITableViewCell {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = SystemImage.search?.withTintColor(
            .primary3,
            renderingMode: .alwaysOriginal
        )

        return imageView
    }()
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(size: 16, weight: .medium)
        
        return label
    }()
    
    private lazy var removeKeywordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SystemImage.remove, for: .normal)
        button.tintColor = .kcsGray2
        button.rx.tap
            .bind { [weak self] in
                guard let self = self,
                      let indexPath = indexPath else { return }
                delegate?.removeKeywordButtonTapped(index: indexPath.row)
            }
            .disposed(by: disposedBag)
        
        return button
    }()
    
    private let disposedBag = DisposeBag()
    private var indexPath: IndexPath?
    var delegate: RecentHistoryTableViewCellDelegate?
    
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
    
    func setIndexPath(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
}

private extension RecentHistoryTableViewCell {
    
    func addUIComponents() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(keywordLabel)
        contentView.addSubview(removeKeywordButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            removeKeywordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeKeywordButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeKeywordButton.widthAnchor.constraint(equalToConstant: 14),
            removeKeywordButton.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        NSLayoutConstraint.activate([
            keywordLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            keywordLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            keywordLabel.trailingAnchor.constraint(equalTo: removeKeywordButton.leadingAnchor, constant: -8)
        ])
    }
    
}
