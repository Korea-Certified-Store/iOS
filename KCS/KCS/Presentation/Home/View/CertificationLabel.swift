//
//  CertificationLabel.swift
//  KCS
//
//  Created by 김영현 on 1/13/24.
//

import UIKit

final class CertificationLabel: UIView {
    
    private let certificationType: CertificationType
    
    private lazy var certificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.certificationLabelText
        switch certificationType {
        case .goodPrice:
            label.text = "착한 가격 업소"
        case .exemplary:
            label.text = "모범 음식점"
        case .safe:
            label.text = "안심 식당"
        }
        
        return label
    }()

    init(certificationType: CertificationType) {
        self.certificationType = certificationType
        super.init(frame: .zero)
        
        setBackgroundColor()
        setLayerCorner(cornerRadius: 9)
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CertificationLabel {
    
    func setBackgroundColor() {
        switch certificationType {
        case .goodPrice:
            backgroundColor = UIColor.goodPriceLabel
        case .exemplary:
            backgroundColor = UIColor.exemplaryLabel
        case .safe:
            backgroundColor = UIColor.safeLabel
        }
    }
    
    func addUIComponents() {
        addSubview(certificationLabel)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            certificationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            certificationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            certificationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            certificationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
        
    }
}
