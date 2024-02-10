//
//  SearchBarView.swift
//  KCS
//
//  Created by 조성민 on 2/9/24.
//

import UIKit
import RxSwift

final class SearchBarView: UIView {
    
    private let disposeBag = DisposeBag()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "가게명, 업종, 주소 검색"
        textField.returnKeyType = .search
        
        return textField
    }()
    
    var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = SystemImage.search
        imageView.tintColor = .grayLabel
        
        return imageView
    }()
    
    var xmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = SystemImage.xmark
        imageView.tintColor = .grayLabel
        imageView.isHidden = true
        
        return imageView
    }()
    
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

private extension SearchBarView {
    
    func setup() {
        backgroundColor = .white
        
        searchTextField.rx.text
            .bind { [weak self] text in
                guard let self = self else { return }
                if let text = text, !text.isEmpty {
                    switchToXmark()
                } else {
                    switchToSearch()
                }
            }
            .disposed(by: disposeBag)
        
        setLayerCorner(cornerRadius: 12)
        setLayerShadow(shadowOffset: CGSize(width: 0, height: 3))
        switchToSearch()
    }
    
    func addUIComponents() {
        addSubview(searchTextField)
        addSubview(xmarkImageView)
        addSubview(searchImageView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            xmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            xmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            xmarkImageView.widthAnchor.constraint(equalToConstant: 16),
            xmarkImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            searchImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchImageView.widthAnchor.constraint(equalToConstant: 16),
            searchImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: xmarkImageView.leadingAnchor, constant: -5)
        ])
    }
    
    func switchToXmark() {
            searchImageView.isHidden = true
            xmarkImageView.isHidden = false
    }
    
    func switchToSearch() {
        searchImageView.isHidden = false
        xmarkImageView.isHidden = true
    }
    
}
