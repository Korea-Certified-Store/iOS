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
    
    private lazy var addressTextField: NewStoreTextField = {
        let textField = NewStoreTextField(xmark: false)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "주소를 검색해 주세요."
        textField.tintColor = .clear
        textField.rx.tapGesture()
            .when(.ended)
            .asObservable()
            .bind { [weak self] _ in
                textField.setSelectedUI()
                textField.endEditing(true)
                self?.presentAddressView()
            }
            .disposed(by: disposeBag)
        
        return textField
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
                self?.presentAddressView()
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
                self?.addressWarningLabel.isHidden = true
            }
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .bind { [weak self] _ in
                self?.viewModel.action(input: .detailAddressEditEnd(text: textField.text ?? ""))
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
        label.textColor = .kcsGray1
        
        return label
    }()
    
    private lazy var goodPriceButton: UIButton = {
        let button = makeToggleButton()
        button.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                requestNewStoreCertificationIsSelected.goodPrice = button.isSelected
                viewModel.action(
                    input: .certificationEditEnd(
                        requestNewStoreCertificationIsSelected: requestNewStoreCertificationIsSelected
                    )
                )
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var exemplaryButton: UIButton = {
        let button = makeToggleButton()
        button.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                requestNewStoreCertificationIsSelected.exemplary = button.isSelected
                viewModel.action(
                    input: .certificationEditEnd(
                        requestNewStoreCertificationIsSelected: requestNewStoreCertificationIsSelected
                    )
                )
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var safeButton: UIButton = {
        let button = makeToggleButton()
        button.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                requestNewStoreCertificationIsSelected.safe = button.isSelected
                viewModel.action(
                    input: .certificationEditEnd(
                        requestNewStoreCertificationIsSelected: requestNewStoreCertificationIsSelected
                    )
                )
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var goodPriceLabel = makeToggleLabel(type: .goodPrice)
    private lazy var exemplaryLabel = makeToggleLabel(type: .exemplary)
    private lazy var safeLabel = makeToggleLabel(type: .safe)
        
    private let certificationWarningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "인증제를 선택해 주세요."
        label.font = .pretendard(size: 12, weight: .regular)
        label.textColor = .uiTextFieldWarning
        label.isHidden = true
        
        return label
    }()
    
    private let viewModel: NewStoreRequestViewModel
    private let addressObserver: PublishRelay<String>
    private var requestNewStoreCertificationIsSelected = RequestNewStoreCertificationIsSelected()
    
    init(viewModel: NewStoreRequestViewModel, 
         addressObserver: PublishRelay<String>
    ) {
        self.viewModel = viewModel
        self.addressObserver = addressObserver
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
        addUIComponents()
        configureConstraints()
    }
    
}

private extension NewStoreRequestViewController {
    
    func makeToggleButton() -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.newStoreRequestTextFieldNormal
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.changesSelectionAsPrimaryAction = true
        button.layer.borderColor = UIColor.uiTextFieldNormalBorder.cgColor
        button.layer.borderWidth = 0.7
        button.setLayerCorner(cornerRadius: 3)
        button.configuration = config
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.image = button.isSelected
            ? UIImage.checkbox
            : nil
            button.configuration = config
        }
        
        return button
    }
    
    func makeToggleLabel(type: CertificationType) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 15, weight: .medium)
        label.text = type.rawValue
        label.textColor = .black
        
        return label
    }
    
}

private extension NewStoreRequestViewController {
    
    func setup() {
        view.backgroundColor = .white
    }
    
    func bind() {
        observerBind()
        titleBind()
        addressBind()
        certificationBind()
        completeBind()
    }
    
    func observerBind() {
        scrollContentView.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        }).when(.ended)
            .bind { [weak self] _ in
                self?.scrollContentView.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        addressObserver
            .bind { [weak self] address in
                self?.addressTextField.text = address
                self?.viewModel.action(input: .addressEditEnd(text: address))
            }
            .disposed(by: disposeBag)
    }
    
    func titleBind() {
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
    
    func addressBind() {
        viewModel.addressEditEndOutput
            .bind { [weak self] in
                self?.addressTextField.setNormalUI()
                self?.addressWarningLabel.isHidden = true
            }
            .disposed(by: disposeBag)
        
        viewModel.addressWarningOutput
            .bind { [weak self] in
                self?.addressTextField.setWarningUI()
                self?.addressWarningLabel.isHidden = false
            }
            .disposed(by: disposeBag)
        
        viewModel.detailAddressEditEndOutput
            .bind { [weak self] in
                self?.detailAddressTextField.setNormalUI()
                self?.addressWarningLabel.isHidden = true
            }
            .disposed(by: disposeBag)
        
        viewModel.detailAddressWarningOutput
            .bind { [weak self] in
                self?.detailAddressTextField.setWarningUI()
                self?.addressWarningLabel.isHidden = false
            }
            .disposed(by: disposeBag)
    }
    
    func certificationBind() {
        viewModel.certificationEditEndOutput
            .bind { [weak self] in
                self?.certificationWarningLabel.isHidden = true
            }
            .disposed(by: disposeBag)
        
        viewModel.certificationWarningOutput
            .bind { [weak self] in
                self?.certificationWarningLabel.isHidden = false
            }
            .disposed(by: disposeBag)
    }
    
    func completeBind() {
        viewModel.completeEditOutput
            .bind { [weak self] in
                self?.rightBarButtonItem.isEnabled = true
            }
            .disposed(by: disposeBag)
        
        viewModel.noCompleteEditOutput
            .bind { [weak self] in
                self?.rightBarButtonItem.isEnabled = false
            }
            .disposed(by: disposeBag)
    }
    
    func addUIComponents() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(titleHeaderLabel)
        scrollContentView.addSubview(titleTextField)
        scrollContentView.addSubview(titleWarningLabel)
        scrollContentView.addSubview(addressHeaderLabel)
        scrollContentView.addSubview(addressTextField)
        scrollContentView.addSubview(searchAddressButton)
        scrollContentView.addSubview(detailAddressTextField)
        scrollContentView.addSubview(addressWarningLabel)
        scrollContentView.addSubview(certificationLabel)
        scrollContentView.addSubview(goodPriceButton)
        scrollContentView.addSubview(goodPriceLabel)
        scrollContentView.addSubview(exemplaryButton)
        scrollContentView.addSubview(exemplaryLabel)
        scrollContentView.addSubview(safeButton)
        scrollContentView.addSubview(safeLabel)
        scrollContentView.addSubview(certificationWarningLabel)
    }
    
    func configureConstraints() {
        scrollViewConstraints()
        titleConstraints()
        addressConstraints()
        certificationConstraints()
    }
    
    func scrollViewConstraints() {
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
    }
    
    func titleConstraints() {
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
    }
    
    func addressConstraints() {
        NSLayoutConstraint.activate([
            addressHeaderLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 48),
            addressHeaderLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            addressTextField.topAnchor.constraint(equalTo: addressHeaderLabel.bottomAnchor, constant: 8),
            addressTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            addressTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -113),
            addressTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            searchAddressButton.centerYAnchor.constraint(equalTo: addressTextField.centerYAnchor),
            searchAddressButton.leadingAnchor.constraint(equalTo: addressTextField.trailingAnchor, constant: 9),
            searchAddressButton.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            searchAddressButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            detailAddressTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 12),
            detailAddressTextField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            detailAddressTextField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            detailAddressTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            addressWarningLabel.topAnchor.constraint(equalTo: detailAddressTextField.bottomAnchor, constant: 6),
            addressWarningLabel.leadingAnchor.constraint(equalTo: detailAddressTextField.leadingAnchor, constant: 16)
        ])
    }
    
    func certificationConstraints() {
        NSLayoutConstraint.activate([
            certificationLabel.topAnchor.constraint(equalTo: detailAddressTextField.bottomAnchor, constant: 48),
            certificationLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            goodPriceButton.topAnchor.constraint(equalTo: certificationLabel.bottomAnchor, constant: 8),
            goodPriceButton.leadingAnchor.constraint(equalTo: certificationLabel.leadingAnchor),
            goodPriceButton.widthAnchor.constraint(equalToConstant: 25),
            goodPriceButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            goodPriceLabel.leadingAnchor.constraint(equalTo: goodPriceButton.trailingAnchor, constant: 8),
            goodPriceLabel.centerYAnchor.constraint(equalTo: goodPriceButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exemplaryButton.topAnchor.constraint(equalTo: goodPriceButton.bottomAnchor, constant: 16),
            exemplaryButton.leadingAnchor.constraint(equalTo: certificationLabel.leadingAnchor),
            exemplaryButton.widthAnchor.constraint(equalToConstant: 25),
            exemplaryButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            exemplaryLabel.leadingAnchor.constraint(equalTo: exemplaryButton.trailingAnchor, constant: 8),
            exemplaryLabel.centerYAnchor.constraint(equalTo: exemplaryButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            safeButton.topAnchor.constraint(equalTo: exemplaryButton.bottomAnchor, constant: 16),
            safeButton.leadingAnchor.constraint(equalTo: certificationLabel.leadingAnchor),
            safeButton.widthAnchor.constraint(equalToConstant: 25),
            safeButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            safeLabel.leadingAnchor.constraint(equalTo: safeButton.trailingAnchor, constant: 8),
            safeLabel.centerYAnchor.constraint(equalTo: safeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            certificationWarningLabel.topAnchor.constraint(equalTo: safeButton.bottomAnchor, constant: 6),
            certificationWarningLabel.leadingAnchor.constraint(equalTo: certificationLabel.leadingAnchor, constant: 16)
        ])
    }
    
}

private extension NewStoreRequestViewController {
    
    func presentAddressView() {
        let addressViewController = AddressViewController(addressObserver: addressObserver)
        present(addressViewController, animated: true) { [weak self] in
            self?.viewModel.action(input: .addressEditEnd(text: self?.addressTextField.text ?? ""))
        }
    }
    
}
