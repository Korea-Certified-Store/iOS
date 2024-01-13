//
//  SummaryInformationView.swift
//  KCS
//
//  Created by 김영현 on 1/11/24.
//

import UIKit

class SummaryInformationView: UIView {
    
    private let storeName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "미식일가"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor.kcsSecondary
        
        return label
    }()
    
//    private let label = CertificationLabel(frame: .zero, certificationType: .goodPrice)
    
    private var certificationStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [CertificationLabel(frame: .zero, certificationType: .goodPrice), CertificationLabel(frame: .zero, certificationType: .exemplary)])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillProportionally
        
        return stack
    }()
    
    private let storeType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "일식"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.kcsGray
        
        return label
    }()
    
    private let storeOpenClosed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "영업 중"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.goodPrice
        
        return label
    }()
    
    private let storeOpeningHours: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "11:00 - 22:30"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor.kcsGray
        
        return label
    }()
    
    private let storeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.kcsLogo
        
        return imageView
    }()
    
    private let storePhoneButton: UIButton = {
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setLayer()
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SummaryInformationView {
    
    func setUI() {
        backgroundColor = .white
    }
    
    func setLayer() {
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.kcsPrimary.cgColor
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 15
        layer.masksToBounds = false
    }
    
    func addUIComponents() {
        addSubview(storeName)
        addSubview(certificationStackView)
        addSubview(storeType)
        addSubview(storeOpenClosed)
        addSubview(storeOpeningHours)
        addSubview(storeImage)
        addSubview(storePhoneButton)
        addSubview(dismissIndicatorView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            storeName.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            storeName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            certificationStackView.topAnchor.constraint(equalTo: storeName.bottomAnchor, constant: 8),
            certificationStackView.leadingAnchor.constraint(equalTo: storeName.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            storeType.centerYAnchor.constraint(equalTo: storeName.centerYAnchor, constant: 2),
            storeType.leadingAnchor.constraint(equalTo: storeName.trailingAnchor, constant: 4)
        ])
        
        NSLayoutConstraint.activate([
            storeOpenClosed.topAnchor.constraint(equalTo: certificationStackView.bottomAnchor, constant: 8),
            storeOpenClosed.leadingAnchor.constraint(equalTo: storeName.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            storeOpeningHours.centerYAnchor.constraint(equalTo: storeOpenClosed.centerYAnchor),
            storeOpeningHours.leadingAnchor.constraint(equalTo: storeOpenClosed.trailingAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            storePhoneButton.topAnchor.constraint(equalTo: storeOpenClosed.bottomAnchor, constant: 13),
            storePhoneButton.leadingAnchor.constraint(equalTo: storeName.leadingAnchor),
            storePhoneButton.widthAnchor.constraint(equalToConstant: 69),
            storePhoneButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            storeImage.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            storeImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            storeImage.widthAnchor.constraint(equalToConstant: 116),
            storeImage.heightAnchor.constraint(equalToConstant: 116)
        ])
        
        NSLayoutConstraint.activate([
            dismissIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 35),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
}
