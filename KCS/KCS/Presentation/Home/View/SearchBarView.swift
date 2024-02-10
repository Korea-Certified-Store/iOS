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
        textField.enablesReturnKeyAutomatically = true
        
        Observable.merge(
            textField.rx.observe(String.self, "text"),
            textField.rx.text.asObservable()
        )
        .bind { [weak self]_ in
            if textField.text?.isEmpty == true {
                self?.switchToSearch()
            } else {
                self?.switchToXMark()
            }
        }
        .disposed(by: disposeBag)
        
        return textField
    }()
    
    var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .searchIcon
        imageView.tintColor = .grayLabel
        
        return imageView
    }()
    
    var xMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .xMarkIcon
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
        
        setLayerCorner(cornerRadius: 12)
        setLayerShadow(shadowOffset: CGSize(width: 0, height: 3))
    }
    
    func addUIComponents() {
        addSubview(searchTextField)
        addSubview(xMarkImageView)
        addSubview(searchImageView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            xMarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            xMarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            xMarkImageView.widthAnchor.constraint(equalToConstant: 16),
            xMarkImageView.heightAnchor.constraint(equalToConstant: 16)
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
            searchTextField.trailingAnchor.constraint(equalTo: xMarkImageView.leadingAnchor, constant: -5)
        ])
    }
    
    func switchToXMark() {
        searchImageView.isHidden = true
        xMarkImageView.isHidden = false
    }
    
    func switchToSearch() {
        searchImageView.isHidden = false
        xMarkImageView.isHidden = true
    }
    
}
