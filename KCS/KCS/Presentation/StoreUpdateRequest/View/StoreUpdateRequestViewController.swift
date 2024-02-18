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
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "",
            image: .backButton.withTintColor(.black, renderingMode: .alwaysOriginal),
            target: self,
            action: nil
        )
        button.rx.tap
            .bind { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var completeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
        button.isEnabled = false
        button.rx.tap
            .bind { [weak self] _ in
                guard let type = self?.typeTextField.text,
                      let content = self?.contentTextView.text else { return }
                self?.viewModel.action(input: .postUpdateRequest(
                    type: type, content: content
                ))
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var customNavigationBar: UINavigationBar = {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let statusBarHeight = scene.windows.first?.safeAreaInsets.top else { return UINavigationBar() }
        let navigationBar = UINavigationBar(frame: .init(x: 0, y: statusBarHeight, width: view.frame.width, height: statusBarHeight))
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .white

        let navigationItem = UINavigationItem(title: "정보 수정 요청")
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = completeButton
        navigationBar.items = [navigationItem]

        return navigationBar
    }()
    
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
                textField.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        let flexibleButton = UIBarButtonItem(systemItem: .flexibleSpace)
        toolBar.setItems([flexibleButton, selectButton], animated: true)
        
        textField.delegate = self
        textField.tintColor = .clear
        textField.rightViewMode = .never
        textField.inputAccessoryView = toolBar
        textField.inputView = pickerView
        textField.placeholder = "신고 유형 선택하기"
        textField.font = .pretendard(size: 15, weight: .medium)
        
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
        textView.contentInset = UIEdgeInsets(top: 12, left: 13, bottom: 12, right: 13)
        
        textView.rx.didBeginEditing
            .bind { [weak self] _ in
                self?.setSelectedUI()
            }
            .disposed(by: disposeBag)
    
        textView.rx.didEndEditing
            .bind { [weak self] _ in
                guard let text = textView.text else { return }
                self?.viewModel.action(input: .contentEndEditing(text: text))
            }
            .disposed(by: disposeBag)
        
        textView.rx.didChange
            .bind { [weak self] _ in
                guard let text = textView.text else { return }
                self?.viewModel.action(input: .contentWhileEditing(text: text))
                self?.contentLengthLabel.text = "\(text.count)/300"
                self?.viewModel.action(
                    input: .completeButtonIsEnable(type: self?.typeTextField.text ?? "", content: self?.contentTextView.text ?? "")
                )
            }
            .disposed(by: disposeBag)
        
        return textView
    }()
    
    private let textViewPlaceHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "신고 내용을 작성해주세요."
        label.font = .pretendard(size: 15, weight: .medium)
        label.textColor = .placeholderText
        label.isUserInteractionEnabled = false
        
        return label
    }()
    
    private let contentWarningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "신고 내용을 수정해 주세요."
        label.font = .pretendard(size: 12, weight: .regular)
        label.textColor = .uiTextFieldWarning
        label.isHidden = true
        
        return label
    }()
    
    private let contentLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/300"
        label.font = .pretendard(size: 12, weight: .regular)
        label.textColor = .kcsGray1
        
        return label
    }()
    
    private let viewModel: StoreUpdateRequestViewModel
    
    init(viewModel: StoreUpdateRequestViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetView()
    }
    
    func setStoreID(id: Int) {
        viewModel.action(input: .setStoreID(id: id))
    }
    
}

private extension StoreUpdateRequestViewController {
    
    func addUIComponents() {
        view.addSubview(customNavigationBar)
        view.addSubview(typeHeaderLabel)
        view.addSubview(typeTextField)
        view.addSubview(typeWarningLabel)
        view.addSubview(contentHeaderLabel)
        view.addSubview(contentTextView)
        view.addSubview(contentWarningLabel)
        view.addSubview(contentLengthLabel)
        contentTextView.addSubview(textViewPlaceHolderLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            typeHeaderLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            typeHeaderLabel.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 35)
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
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            textViewPlaceHolderLabel.topAnchor.constraint(equalTo: contentTextView.topAnchor, constant: 8),
            textViewPlaceHolderLabel.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            contentWarningLabel.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 6),
            contentWarningLabel.leadingAnchor.constraint(equalTo: contentTextView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            contentLengthLabel.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 8),
            contentLengthLabel.trailingAnchor.constraint(equalTo: contentTextView.trailingAnchor)
        ])
    }
    
    func setup() {
        view.backgroundColor = .white
        modalPresentationStyle = .fullScreen
        setNormalUI()
    }
    
    func bind() {
        bindKeyboard()
        bindType()
        bindContent()
        bindComplete()
        bindAlert()
    }
    
    func bindKeyboard() {
        view.rx.tapGesture { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        }
        .bind { [weak self] _ in
            self?.view.endEditing(true)
        }
        .disposed(by: disposeBag)
    }
    
    func bindType() {
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
    }
    
    func bindContent() {
        viewModel.contentEditEndOutput
            .bind { [weak self] in
                self?.setNormalUI()
            }
            .disposed(by: disposeBag)
        
        viewModel.contentWarningOutput
            .bind { [weak self] in
                self?.setWarningUI()
            }
            .disposed(by: disposeBag)
        
        viewModel.contentFillPlaceHolder
            .bind { [weak self] in
                self?.textViewPlaceHolderLabel.isHidden = false
            }
            .disposed(by: disposeBag)
        
        viewModel.contentErasePlaceHolder
            .bind { [weak self] in
                self?.textViewPlaceHolderLabel.isHidden = true
            }
            .disposed(by: disposeBag)
        
        viewModel.contentLengthNormalOutput
            .bind { [weak self] in
                self?.contentLengthLabel.textColor = .kcsGray1
            }
            .disposed(by: disposeBag)
        
        viewModel.contentLengthWarningOutput
            .bind { [weak self] in
                self?.contentLengthLabel.textColor = .uiTextFieldWarning
            }
            .disposed(by: disposeBag)
    }
    
    func bindComplete() {
        viewModel.completeButtonIsEnabledOutput
            .bind { [weak self] bool in
                self?.completeButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
    }
    
    func bindAlert() {
        viewModel.errorAlertOutput
            .bind { [weak self] error in
                self?.presentErrorAlert(error: error)
            }
            .disposed(by: disposeBag)
        
        viewModel.completeRequestOutput
            .bind { [weak self] _ in
                let alertController = UIAlertController(
                    title: "",
                    message: "정보 수정 요청이 완료되었습니다.\n제보 내용은 검토 후에 조치하겠습니다.",
                    preferredStyle: .alert
                )
                let alertAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                    self?.dismiss(animated: true)
                }
                alertController.addAction(alertAction)
                self?.present(alertController, animated: true)
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
        contentLengthLabel.textColor = .uiTextFieldWarning
    }
    
    func setNormalUI() {
        contentTextView.backgroundColor = .newStoreRequestTextFieldNormal
        contentTextView.layer.borderWidth = 0.7
        contentTextView.layer.borderColor = UIColor.uiTextFieldNormalBorder.cgColor
        contentWarningLabel.isHidden = true
    }
    
    func resetView() {
        typeTextField.setNormalUI()
        setNormalUI()
        typeTextField.text = ""
        contentTextView.text = ""
        contentLengthLabel.text = "0/300"
        typeWarningLabel.isHidden = true
        textViewPlaceHolderLabel.isHidden = false
        completeButton.isEnabled = false
    }
    
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
            return "신고 유형 선택하기"
        case 1:
            return "수정"
        case 2:
            return "삭제"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 1:
            typeTextField.text = "수정"
        case 2:
            typeTextField.text = "삭제"
        default:
            typeTextField.text = ""
        }
        viewModel.action(input: .completeButtonIsEnable(type: typeTextField.text ?? "", content: contentTextView.text ?? ""))
    }
    
}

extension StoreUpdateRequestViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == typeTextField {
            return false
        } else {
            return true
        }
    }
    
}
