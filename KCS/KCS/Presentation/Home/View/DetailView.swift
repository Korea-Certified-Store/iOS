//
//  DetailView.swift
//  KCS
//
//  Created by 조성민 on 1/24/24.
//

import UIKit
import RxSwift

// TODO: UI 요소 전체를 디자인에 맞게 수정해야 합니다.
final class DetailView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private lazy var storeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 22, weight: .bold)
        label.textColor = UIColor.primary2
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var category: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 13, weight: .regular)
        label.textColor = UIColor.kcsGray
        
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
    
    private lazy var storeOpenClosed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 15, weight: .regular)
        label.textColor = UIColor.goodPrice
        
        return label
    }()
    
    private lazy var openingHour: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 13, weight: .regular)
        label.textColor = UIColor.kcsGray
        
        return label
    }()
    
    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setLayerCorner(cornerRadius: 6)
        imageView.clipsToBounds = true
        imageView.image = UIImage.basicStore
        
        return imageView
    }()
    
    private let address: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let phoneNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dismissIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.swipeBar
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    private let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setBackgroundColor()
        setLayerCorner(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        addUIComponents()
        configureConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension DetailView {
    
    func bind() {
        
    }
    
}

private extension DetailView {
    
    func setBackgroundColor() {
        //        backgroundColor = .white
        backgroundColor = .systemYellow
    }
    
    func addUIComponents() {
        addSubview(storeTitle)
        addSubview(certificationStackView)
        addSubview(category)
        addSubview(storeOpenClosed)
        addSubview(openingHour)
        addSubview(storeImageView)
        addSubview(dismissIndicatorView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            storeTitle.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            storeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            storeTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -156)
        ])
        
        NSLayoutConstraint.activate([
            category.topAnchor.constraint(equalTo: storeTitle.bottomAnchor, constant: 4),
            category.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            certificationStackView.topAnchor.constraint(equalTo: category.bottomAnchor, constant: 9),
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
            storeImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27),
            storeImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            storeImageView.widthAnchor.constraint(equalToConstant: 132),
            storeImageView.heightAnchor.constraint(equalToConstant: 132)
        ])
        
        NSLayoutConstraint.activate([
            dismissIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 35),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    func removeStackView() {
        let subviews = certificationStackView.arrangedSubviews
        certificationStackView.arrangedSubviews.forEach {
            certificationStackView.removeArrangedSubview($0)
        }
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func callTapped() {
        if let number = phoneNumber.text, let url = URL(string: "tel://" + "\(number.filter { $0.isNumber })") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

extension DetailView {
    
    func setUIContents(store: Store) {
        
    }
    
}
