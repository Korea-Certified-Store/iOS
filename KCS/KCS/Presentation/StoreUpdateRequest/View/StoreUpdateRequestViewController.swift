//
//  StoreUpdateRequestViewController.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class StoreUpdateRequestViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let typeHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "신고 유형"
        label.font = .pretendard(size: 14, weight: .medium)
        label.textColor = .kcsGray1
        
        return label
    }()
    
    private lazy var typeTextField: NewStoreTextField = {
        let textField = NewStoreTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        let selectButton = UIBarButtonItem(
            title: "확인",
            style: .plain,
            target: self,
            action: nil
        )
        selectButton.rx.tap
            .bind { [weak self] _ in
                // TODO: 확인 버튼 눌렀을 때 동작 구현
            }
            .disposed(by: disposeBag)
        
        let flexibleButton = UIBarButtonItem(systemItem: .flexibleSpace)
        toolBar.setItems([flexibleButton, selectButton], animated: true)
        
        textField.rightViewMode = .never
        textField.inputAccessoryView = toolBar
        textField.inputView = pickerView
        
        textField.rx.controlEvent([.editingDidBegin])
            .bind { [weak self] _ in
                textField.setSelectedUI()
                self?.typeWarningLabel.isHidden = true
            }
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent([.editingDidEnd])
            .bind { [weak self] _ in
                guard let text = textField.text else { return }
                self?.viewModel.action(input: .typeInput(text: text))
            }
            .disposed(by: disposeBag)
        
        return textField
    }()
    
    private let typeWarningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "신고 유형을 선택해 주세요."
        label.font = .pretendard(size: 12, weight: .regular)
        label.textColor = .uiTextFieldWarning
        label.isHidden = true
        
        return label
    }()
    
    private let contentHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "신고 내용"
        label.font = .pretendard(size: 14, weight: .medium)
        label.textColor = .kcsGray1
        
        return label
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setLayerCorner(cornerRadius: 10)
        textView.font = .pretendard(size: 15, weight: .medium)
        textView.layer.borderWidth = 1.5
        textView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.delegate = self
        textView.rx.didBeginEditing
            .bind { [weak self] _ in
                self?.setSelectedUI()
            }
            .disposed(by: disposeBag)
    
        textView.rx.didEndEditing
            .bind { [weak self] _ in
                guard let text = textView.text else { return }
                self?.viewModel.action(input: .contentInput(text: text))
            }
            .disposed(by: disposeBag)
        
        return textView
    }()
    
    private let contentWarningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "신고 내용을 작성해 주세요."
        label.font = .pretendard(size: 12, weight: .regular)
        label.textColor = .uiTextFieldWarning
        label.isHidden = true
        
        return label
    }()
    
    private let viewModel: StoreUpdateRequestViewModel
    
    init(viewModel: StoreUpdateRequestViewModel) {
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

private extension StoreUpdateRequestViewController {
    
    func addUIComponents() {
        view.addSubview(typeHeaderLabel)
        view.addSubview(typeTextField)
        view.addSubview(typeWarningLabel)
        view.addSubview(contentHeaderLabel)
        view.addSubview(contentTextView)
        view.addSubview(contentWarningLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            typeHeaderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            typeHeaderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35)
        ])
        
        NSLayoutConstraint.activate([
            typeTextField.topAnchor.constraint(equalTo: typeHeaderLabel.bottomAnchor, constant: 8),
            typeTextField.leadingAnchor.constraint(equalTo: typeHeaderLabel.leadingAnchor),
            typeTextField.widthAnchor.constraint(equalToConstant: 144),
            typeTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            typeWarningLabel.topAnchor.constraint(equalTo: typeTextField.bottomAnchor, constant: 6),
            typeWarningLabel.leadingAnchor.constraint(equalTo: typeTextField.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            contentHeaderLabel.topAnchor.constraint(equalTo: typeTextField.bottomAnchor, constant: 48),
            contentHeaderLabel.leadingAnchor.constraint(equalTo: typeTextField.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: contentHeaderLabel.bottomAnchor, constant: 8),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            contentTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            contentWarningLabel.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 6),
            contentWarningLabel.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor, constant: 16)
        ])
    }
    
    func setup() {
        view.backgroundColor = .white
        setNormalUI()
    }
    
    func bind() {
        viewModel.typeEditEndOutput
            .bind { [weak self] in
                self?.typeTextField.setNormalUI()
                self?.typeWarningLabel.isHidden = true
            }
            .disposed(by: disposeBag)
        
        viewModel.typeWarningOutput
            .bind { [weak self] in
                self?.typeTextField.setWarningUI()
                self?.typeWarningLabel.isHidden = false
            }
            .disposed(by: disposeBag)
        
        viewModel.contentEditEndOutput
            .bind { [weak self] in
                self?.setSelectedUI()
            }
            .disposed(by: disposeBag)
        
        viewModel.contentWarningOutput
            .bind { [weak self] in
                self?.setWarningUI()
            }
            .disposed(by: disposeBag)
    }
    
}

private extension StoreUpdateRequestViewController {
    
    func setSelectedUI() {
        contentTextView.backgroundColor = .newStoreRequestTextFieldEdit
        contentTextView.layer.borderWidth = 1.5
        contentTextView.layer.borderColor = UIColor.uiTextFieldBoldBorder.cgColor
        contentWarningLabel.isHidden = true
    }
    
    func setWarningUI() {
        contentTextView.backgroundColor = .newStoreRequestTextFieldNormal
        contentTextView.layer.borderWidth = 1.5
        contentTextView.layer.borderColor = UIColor.uiTextFieldWarning.cgColor
        contentWarningLabel.isHidden = false
    }
    
    func setNormalUI() {
        contentTextView.backgroundColor = .newStoreRequestTextFieldNormal
        contentTextView.layer.borderWidth = 0.7
        contentTextView.layer.borderColor = UIColor.uiTextFieldNormalBorder.cgColor
        contentWarningLabel.isHidden = true
    }
}

extension StoreUpdateRequestViewController: UITextViewDelegate {
    
}

extension StoreUpdateRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "수정"
        case 1:
            return "삭제"
        case 2:
            return "기타"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO: 선택했을때 동작
    }
    
}
