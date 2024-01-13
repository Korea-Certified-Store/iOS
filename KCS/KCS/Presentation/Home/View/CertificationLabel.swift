//
//  CertificationLabel.swift
//  KCS
//
//  Created by 김영현 on 1/13/24.
//

import UIKit

final class CertificationLabel: UIView {
    
    private var certificationType: CetificationType?
    
    private lazy var certificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 9)
        label.textColor = UIColor.certificationLabelText
        switch certificationType {
        case .goodPrice:
            label.text = certificationType?.rawValue
        case .exemplary:
            label.text = certificationType?.rawValue
        case .safe:
            label.text = certificationType?.rawValue
        default:
            break
        }
        
        return label
    }()

    init(frame: CGRect, certificationType: CetificationType) {
        super.init(frame: frame)
        
        self.certificationType = certificationType
        setUI()
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CertificationLabel {
    
    func setUI() {
        switch certificationType {
        case .goodPrice:
            backgroundColor = UIColor.goodPriceLabel
        case .exemplary:
            backgroundColor = UIColor.exemplaryLabel
        case .safe:
            backgroundColor = UIColor.safeLabel
        default:
            break
        }
        layer.cornerRadius = 9
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
