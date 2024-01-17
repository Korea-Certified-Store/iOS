//
//  SummaryInformationView.swift
//  KCS
//
//  Created by 김영현 on 1/11/24.
//

import UIKit

final class SummaryInformationView: UIView {
    
    private let store: Store
    
    private lazy var storeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = store.title
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor.primary2
        
        return label
    }()
    
    private lazy var certificationStackView: UIStackView = {
        let labels = store.certificationTypes.map({ CertificationLabel(certificationType: $0) })
        let stack = UIStackView(arrangedSubviews: labels)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillProportionally
        
        return stack
    }()
    
    private lazy var categoty: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = store.category
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.kcsGray
        
        return label
    }()
    
    private let storeOpenClosed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.goodPrice
        
        return label
    }()
    
    private let openingHour: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor.kcsGray
        
        return label
    }()
    
    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    init(store: Store) {
        self.store = store
        super.init(frame: .zero)
        
        setBackgroundColor()
        setLayerShadow(shadowOffset: .zero)
        setLayerCorner(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SummaryInformationView {
    
    func setBackgroundColor() {
        backgroundColor = .white
    }
    
    func addUIComponents() {
        addSubview(storeTitle)
        addSubview(certificationStackView)
        addSubview(categoty)
        addSubview(storeOpenClosed)
        addSubview(openingHour)
        addSubview(storeImageView)
        addSubview(storeCallButton)
        addSubview(dismissIndicatorView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            storeTitle.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            storeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            certificationStackView.topAnchor.constraint(equalTo: storeTitle.bottomAnchor, constant: 8),
            certificationStackView.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            categoty.centerYAnchor.constraint(equalTo: storeTitle.centerYAnchor, constant: 2),
            categoty.leadingAnchor.constraint(equalTo: storeTitle.trailingAnchor, constant: 4)
        ])
        
        NSLayoutConstraint.activate([
            storeOpenClosed.topAnchor.constraint(equalTo: certificationStackView.bottomAnchor, constant: 8),
            storeOpenClosed.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            openingHour.centerYAnchor.constraint(equalTo: storeOpenClosed.centerYAnchor),
            openingHour.leadingAnchor.constraint(equalTo: storeOpenClosed.trailingAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            storeCallButton.topAnchor.constraint(equalTo: storeOpenClosed.bottomAnchor, constant: 13),
            storeCallButton.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor),
            storeCallButton.widthAnchor.constraint(equalToConstant: 69),
            storeCallButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            storeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            storeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            storeImageView.widthAnchor.constraint(equalToConstant: 116),
            storeImageView.heightAnchor.constraint(equalToConstant: 116)
        ])
        
        NSLayoutConstraint.activate([
            dismissIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 35),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
}
