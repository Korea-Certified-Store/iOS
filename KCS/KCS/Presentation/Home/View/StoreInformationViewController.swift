//
//  StoreInformationViewController.swift
//  KCS
//
//  Created by 김영현 on 1/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class StoreInformationViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var storeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = UIColor.primary2
        label.numberOfLines = 2
        
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
    
    private lazy var categoty: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.kcsGray
        
        return label
    }()
    
    private lazy var storeOpenClosed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.goodPrice
        
        return label
    }()
    
    private lazy var openingHour: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.kcsGray
        
        return label
    }()
    
    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setLayerCorner(cornerRadius: 6)
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let storeCallButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.image = SystemImage.phone
        config.cornerStyle = .capsule
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        
        return button
    }()
    
    private let dismissIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.swipeBar
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    let contentHeightObserver = PublishRelay<CGFloat>()
    private let viewModel: StoreInformationViewModel
    
    init(viewModel: StoreInformationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setBackgroundColor()
        addUIComponents()
        configureConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StoreInformationViewController {
    
    func bind() {
        viewModel.thumbnailImageOutput
            .subscribe(onNext: { [weak self] data in
                self?.storeImageView.image = UIImage(data: data)
            })
            .disposed(by: disposeBag)
        
        viewModel.openClosedOutput
            .bind { [weak self] openClosedContent in
                self?.storeOpenClosed.text = openClosedContent.openClosedType.rawValue
                self?.openingHour.text = openClosedContent.openingHour
            }
            .disposed(by: disposeBag)
        
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    func addUIComponents() {
        view.addSubview(storeTitle)
        view.addSubview(certificationStackView)
        view.addSubview(categoty)
        view.addSubview(storeOpenClosed)
        view.addSubview(openingHour)
        view.addSubview(storeImageView)
        view.addSubview(storeCallButton)
        view.addSubview(dismissIndicatorView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            storeTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            storeTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            storeTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -156)
        ])
        
        NSLayoutConstraint.activate([
            categoty.topAnchor.constraint(equalTo: storeTitle.bottomAnchor, constant: 4),
            categoty.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            certificationStackView.topAnchor.constraint(equalTo: categoty.bottomAnchor, constant: 9),
            certificationStackView.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            storeOpenClosed.topAnchor.constraint(equalTo: certificationStackView.bottomAnchor, constant: 8),
            storeOpenClosed.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            openingHour.centerYAnchor.constraint(equalTo: storeOpenClosed.centerYAnchor),
            openingHour.leadingAnchor.constraint(equalTo: storeOpenClosed.trailingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            storeCallButton.topAnchor.constraint(equalTo: storeOpenClosed.bottomAnchor, constant: 21),
            storeCallButton.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor),
            storeCallButton.widthAnchor.constraint(equalToConstant: 69),
            storeCallButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            storeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            storeImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            storeImageView.widthAnchor.constraint(equalToConstant: 132),
            storeImageView.heightAnchor.constraint(equalToConstant: 132)
        ])
        
        NSLayoutConstraint.activate([
            dismissIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 35),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
}

extension StoreInformationViewController {
    
    func setUIContents(store: Store) {
        storeTitle.text = store.title
        categoty.text = store.category
        removeStackView()
        store.certificationTypes
            .map({
                CertificationLabel(certificationType: $0)
            })
            .forEach {
                certificationStackView.addArrangedSubview($0)
            }
        if let phoneNum = store.phoneNumber {
            storeCallButton.rx.tap
                .bind { [weak self] _ in
                    self?.callButtonTapped(phoneNum: phoneNum)
                }
                .disposed(by: disposeBag)
        }
        viewModel.action(input: .setInformationView(
            openingHour: store.openingHour,
            url: store.localPhotos.first)
        )
        if storeTitle.numberOfVisibleLines > 1 {
            contentHeightObserver.accept(253)
        } else {
            contentHeightObserver.accept(230)
        }
    }
    
}

private extension StoreInformationViewController {
    
    func removeStackView() {
        let subviews = certificationStackView.arrangedSubviews
        certificationStackView.arrangedSubviews.forEach {
            certificationStackView.removeArrangedSubview($0)
        }
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func callButtonTapped(phoneNum: String) {
        if let url = URL(string: "tel://" + "\(phoneNum.filter { $0.isNumber })") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
