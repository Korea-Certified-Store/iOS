//
//  SummaryInformationView.swift
//  KCS
//
//  Created by 김영현 on 1/11/24.
//

import UIKit

final class SummaryInformationView: UIView {
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor.kcsSecondary
        label.text = "미식반점"
        
        return label
    }()
    
    private var certificationStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [CertificationLabel(certificationType: .goodPrice)])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillProportionally
        
        return stack
    }()
    
    private let categoty: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.kcsGray
        label.text = "일식"
        
        return label
    }()
    
    private let storeOpenClosed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.goodPrice
        label.text = "영업 중"
        
        return label
    }()
    
    private let openingHour: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor.kcsGray
        label.text = "11:00 -23:00"
        
        return label
    }()
    
    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.kcsLogo
        
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
    
    override init(frame: CGRect) {
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
        addSubview(title)
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
            title.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            certificationStackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            certificationStackView.leadingAnchor.constraint(equalTo: title.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            categoty.centerYAnchor.constraint(equalTo: title.centerYAnchor, constant: 2),
            categoty.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 4)
        ])
        
        NSLayoutConstraint.activate([
            storeOpenClosed.topAnchor.constraint(equalTo: certificationStackView.bottomAnchor, constant: 8),
            storeOpenClosed.leadingAnchor.constraint(equalTo: title.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            openingHour.centerYAnchor.constraint(equalTo: storeOpenClosed.centerYAnchor),
            openingHour.leadingAnchor.constraint(equalTo: storeOpenClosed.trailingAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            storeCallButton.topAnchor.constraint(equalTo: storeOpenClosed.bottomAnchor, constant: 13),
            storeCallButton.leadingAnchor.constraint(equalTo: title.leadingAnchor),
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
