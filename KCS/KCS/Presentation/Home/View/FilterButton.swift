//
//  FilterButton.swift
//  KCS
//
//  Created by 김영현 on 1/10/24.
//

import UIKit

final class FilterButton: UIButton {
    
    init(type: CertificationType) {
        super.init(frame: .zero)
        setUI()
        setContents(type: type)
        setLayerShadow(shadowOffset: CGSize(width: 0, height: 2))
        configurationHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension FilterButton {
    
    func setUI() {
        var config = UIButton.Configuration.filled()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10)
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 10, bottom: 11, trailing: 10)
        configuration = config
    }
    
    func setContents(type: CertificationType) {
        var titleAttribute = AttributedString.init(type.description)
        titleAttribute.font = .systemFont(ofSize: 10)
        
        guard var config = configuration else { return }
        config.attributedTitle = titleAttribute
        config.image = SystemImage.circle?.withTintColor(
            getColor(type: type),
            renderingMode: .alwaysOriginal
        )
        configuration = config
    }
    
    func configurationHandler() {
        let handler: UIButton.ConfigurationUpdateHandler = { [weak self] button in
            switch button.state {
            case .selected:
                self?.configuration?.baseBackgroundColor = .primary3
                self?.configuration?.baseForegroundColor = .white
            case .normal:
                self?.configuration?.baseBackgroundColor = .white
                self?.configuration?.baseForegroundColor = .black
            default:
                break
            }
        }
        configurationUpdateHandler = handler
    }
    
    func getColor(type: CertificationType) -> UIColor {
        switch type {
        case .goodPrice:
            return .goodPrice
        case .exemplary:
            return .exemplary
        case .safe:
            return .safe
        }
    }
    
}
