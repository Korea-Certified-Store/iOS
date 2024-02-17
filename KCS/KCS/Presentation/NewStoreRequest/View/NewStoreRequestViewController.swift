//
//  NewStoreRequestViewController.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import UIKit
import RxSwift
import RxGesture

final class NewStoreRequestViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let titleHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "가게명"
        
        return label
    }()

    private lazy var titleTextField: NewStoreTextField = {
        let textField = NewStoreTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.rx.text
            .bind { optionalText in
                guard let text = optionalText else { return }
                
            }
            .disposed(by: disposeBag)
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        setup()
    }
    
}

private extension NewStoreRequestViewController {
    
    func addUIComponents() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(titleHeaderLabel)
        scrollContentView.addSubview(titleTextField)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.contentLayoutGuide.heightAnchor.constraint(equalToConstant: 600)
        ])
        
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleHeaderLabel.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 35),
            titleHeaderLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleHeaderLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setup() {
        view.backgroundColor = .white
    }
    
}

extension NewStoreRequestViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .newStoreRequestTextFieldEdit
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = .newStoreRequestTextFieldNormal
    }
    
}
