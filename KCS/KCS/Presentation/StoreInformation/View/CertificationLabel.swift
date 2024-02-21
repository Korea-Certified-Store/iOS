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
        label.font = UIFont.pretendard(size: 9, weight: .medium)
        label.textColor = UIColor.kcsGray1
        label.text = certificationType.rawValue
        
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
