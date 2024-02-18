//
//  NewStoreRequestViewController.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class NewStoreRequestViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.target = self
        barButton.image = UIImage(systemName: "chevron.backward")
        barButton.tintColor = .black
        barButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        return barButton
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.target = self
        barButton.title = "완료"
        barButton.isEnabled = false
        
        return barButton
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let statusBarHeight = scene.windows.first?.safeAreaInsets.top else { return UINavigationBar() }
        let navigationBar = UINavigationBar(frame: .init(x: 0, y: statusBarHeight, width: view.frame.width, height: statusBarHeight))
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = .white
        
        let navigationItem = UINavigationItem(title: "새로운 가게 추가")
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationBar.items = [navigationItem]
        
        return navigationBar
    }()
    
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
            .bind { [weak self] _ in
                textField.setSelectedUI()
                self?.titleWarningLabel.isHidden = true
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
    
    private let titleWarningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "가게명을 입력해 주세요."
        label.font = .pretendard(size: 12, weight: .regular)
        label.textColor = .uiTextFieldWarning
        label.isHidden = true
        
        return label
    }()
    
    private let addressHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "주소"
        label.font = .pretendard(size: 14, weight: .medium)
        label.textColor = .kcsGray1
        
        return label
    }()
    
    private lazy var addressTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setLayerCorner(cornerRadius: 10)
        textView.tintColor = .clear
        textView.font = .pretendard(size: 15, weight: .medium)
        textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        textView.rx.tapGesture()
            .when(.ended)
            .bind { [weak self] _ in
                self?.setSelectedUI()
                guard let self = self else { return }
                let addressViewController = AddressViewController(addressObserver: addressObserver)
                present(addressViewController, animated: true)
            }
            .disposed(by: disposeBag)
//        textView.rx.didBeginEditing
//            .bind { [weak self] _ in
//                self?.setSelectedUI()
//                guard let self = self else { return }
//                let addressViewController = AddressViewController(addressObserver: addressObserver)
//                present(addressViewController, animated: true)
//            }
//            .disposed(by: disposeBag)
        
        return textView
    }()
    
    private let addressTextViewPlaceHolderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "주소를 검색해 주세요."
        label.font = .pretendard(size: 17, weight: .regular)
        label.textColor = .placeholderText
        label.isUserInteractionEnabled = false
//        label.isHidden = true
        
        return label
    }()
    
    private lazy var searchAddressButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("주소 검색", for: .normal)
        button.titleLabel?.font = UIFont.pretendard(size: 15, weight: .medium)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .placeholderText
        button.layer.borderColor = UIColor.kcsGray1.cgColor
        button.layer.borderWidth = 0.7
        button.setLayerCorner(cornerRadius: 10)
        button.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                let addressViewController = AddressViewController(addressObserver: addressObserver)
                present(addressViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var detailAddressTextField: NewStoreTextField = {
        let textField = NewStoreTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "상세 주소를 입력해 주세요."
        textField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .bind { [weak self] _ in
                textField.setSelectedUI()
                self?.titleWarningLabel.isHidden = true
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
    
    private let addressWarningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "주소를 입력해 주세요."
        label.font = .pretendard(size: 12, weight: .regular)
        label.textColor = .uiTextFieldWarning
        label.isHidden = true
        
        return label
    }()
    
    private let certificationLabel: UILabel = {
        let text = "인증제 (중복선택 가능)"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .font,
            value: UIFont.pretendard(size: 12, weight: .regular),
            range: (text as NSString).range(of: "(중복선택 가능)")
        )
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 14, weight: .medium)
        label.attributedText = attributedString
        
        return label
    }()
    
    private let viewModel: NewStoreRequestViewModel
    private let addressObserver: PublishRelay<String>
    
    init(viewModel: NewStoreRequestViewModel, addressObserver: PublishRelay<String>) {
        self.viewModel = viewModel
        self.addressObserver = addressObserver
        
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
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(titleHeaderLabel)
        scrollContentView.addSubview(titleTextField)
        scrollContentView.addSubview(titleWarningLabel)
        scrollContentView.addSubview(addressHeaderLabel)
        scrollContentView.addSubview(addressTextView)
        scrollContentView.addSubview(searchAddressButton)
        scrollContentView.addSubview(detailAddressTextField)
        scrollContentView.addSubview(addressWarningLabel)
        addressTextView.addSubview(addressTextViewPlaceHolderLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
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
            titleHeaderLabel.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 25),
            titleHeaderLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleHeaderLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            titleWarningLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 6),
            titleWarningLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            addressHeaderLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 48),
            addressHeaderLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            addressTextView.topAnchor.constraint(equalTo: addressHeaderLabel.bottomAnchor, constant: 8),
            addressTextView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            addressTextView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -113),
            addressTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            searchAddressButton.centerYAnchor.constraint(equalTo: addressTextView.centerYAnchor),
            searchAddressButton.leadingAnchor.constraint(equalTo: addressTextView.trailingAnchor, constant: 9),
            searchAddressButton.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            searchAddressButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            detailAddressTextField.topAnchor.constraint(equalTo: addressTextView.bottomAnchor, constant: 12),
            detailAddressTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            detailAddressTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            detailAddressTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            addressWarningLabel.topAnchor.constraint(equalTo: detailAddressTextField.bottomAnchor, constant: 6),
            addressWarningLabel.leadingAnchor.constraint(equalTo: detailAddressTextField.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            addressTextViewPlaceHolderLabel.topAnchor.constraint(equalTo: addressTextView.topAnchor, constant: 7),
            addressTextViewPlaceHolderLabel.leadingAnchor.constraint(equalTo: addressTextView.leadingAnchor, constant: 8)
        ])
    }
    
    func setup() {
        view.backgroundColor = .white
        setNormalUI()
    }
    
    func bind() {
        scrollContentView.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
          }).when(.ended)
            .bind { [weak self] _ in
                self?.scrollContentView.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        addressObserver
            .bind { [weak self] address in
                self?.addressTextView.text = address
                self?.addressTextViewPlaceHolderLabel.isHidden = true
                self?.setNormalUI()
            }
            .disposed(by: disposeBag)
        
        viewModel.titleEditEndOutput
            .bind { [weak self] in
                self?.titleTextField.setNormalUI()
                self?.titleWarningLabel.isHidden = true
            }
            .disposed(by: disposeBag)
        
        viewModel.titleWarningOutput
            .bind { [weak self] in
                self?.titleTextField.setWarningUI()
                self?.titleWarningLabel.isHidden = false
            }
            .disposed(by: disposeBag)
    }
    
}

private extension NewStoreRequestViewController {
    
    func setSelectedUI() {
        addressTextView.backgroundColor = .newStoreRequestTextFieldEdit
        addressTextView.layer.borderWidth = 1.5
        addressTextView.layer.borderColor = UIColor.uiTextFieldBoldBorder.cgColor
        addressWarningLabel.isHidden = true
    }
    
    func setWarningUI() {
        addressTextView.backgroundColor = .newStoreRequestTextFieldNormal
        addressTextView.layer.borderWidth = 1.5
        addressTextView.layer.borderColor = UIColor.uiTextFieldWarning.cgColor
        addressWarningLabel.isHidden = false
    }
    
    func setNormalUI() {
        addressTextView.backgroundColor = .newStoreRequestTextFieldNormal
        addressTextView.layer.borderWidth = 0.7
        addressTextView.layer.borderColor = UIColor.uiTextFieldNormalBorder.cgColor
        addressWarningLabel.isHidden = true
    }
    
}
