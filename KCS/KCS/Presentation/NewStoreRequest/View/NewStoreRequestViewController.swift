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
        label.font = .pretendard(size: 14, weight: .medium)
        label.textColor = .kcsGray1
        
        return label
    }()

    private lazy var titleTextField: NewStoreTextField = {
        let textField = NewStoreTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "가게명 입력하기"
        textField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .bind { _ in
                textField.setSelectedUI()
            }
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .bind { [weak self] _ in
                self?.viewModel.action(input: .titleEditEnd(text: textField.text ?? ""))
            }
            .disposed(by: disposeBag)
        
        return textField
    }()
    
    private let viewModel: NewStoreRequestViewModel
    
    init(viewModel: NewStoreRequestViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        setup()
        bind()
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
    
    func bind() {
        view.rx.tapGesture()
            .when(.ended)
            .bind { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        viewModel.titleEditEndOutput
            .bind { [weak self] in
                self?.titleTextField.setNormalUI()
            }
            .disposed(by: disposeBag)
        
        viewModel.titleWarningOutput
            .bind { [weak self] in
                self?.titleTextField.setWarningUI()
            }
            .disposed(by: disposeBag)
    }
    
}
