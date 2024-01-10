//
//  FilterButton.swift
//  KCS
//
//  Created by 김영현 on 1/10/24.
//

import UIKit

final class FilterButton: UIButton {
    
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configure(title: title, color: color)
        configurationHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension FilterButton {
    
    func configure(title: String, color: UIColor) {
        var config = UIButton.Configuration.filled()
        var titleAttribute = AttributedString.init(title)
        titleAttribute.font = .systemFont(ofSize: 10)
        config.attributedTitle = titleAttribute
        config.image = UIImage(systemName: "circle.fill")?.withTintColor(color, renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10)
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 10, bottom: 11, trailing: 10)
        configuration = config
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.cgColor
    }
    
    func configurationHandler() {
        
        self.changesSelectionAsPrimaryAction = true
        
        let handler: UIButton.ConfigurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                self.configuration?.baseBackgroundColor = ColorSet.selectedColor
                self.configuration?.baseForegroundColor = .white
            default:
                self.configuration?.baseBackgroundColor = .white
                self.configuration?.baseForegroundColor = .black
            }
        }
        self.configurationUpdateHandler = handler
    }
    
}
