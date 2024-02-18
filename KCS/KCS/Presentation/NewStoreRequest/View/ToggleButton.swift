//
//  ToggleButton.swift
//  KCS
//
//  Created by 김영현 on 2/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ToggleButton: UIView {
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.changesSelectionAsPrimaryAction = true
        button.layer.borderColor = UIColor.uiTextFieldNormalBorder.cgColor
        button.layer.borderWidth = 0.7
        button.setLayerCorner(cornerRadius: 3)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.newStoreRequestTextFieldNormal
        
        button.configuration = config
        button.configurationUpdateHandler = { button in
          var config = button.configuration
          config?.image = button.isSelected
            ? UIImage.checkbox
            : nil
          button.configuration = config
        }
        
        return button
    }()
    
    private let toggleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 15, weight: .medium)
        label.textColor = .black
        
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setToggleLabel(type: CertificationType) {
        toggleLabel.text = type.rawValue
    }
    
}

private extension ToggleButton {
    
    func addUIComponents() {
        addSubview(toggleButton)
        addSubview(toggleLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            toggleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            toggleButton.topAnchor.constraint(equalTo: topAnchor),
            toggleButton.widthAnchor.constraint(equalToConstant: 25),
            toggleButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            toggleLabel.leadingAnchor.constraint(equalTo: toggleButton.trailingAnchor, constant: 5),
            toggleLabel.centerYAnchor.constraint(equalTo: toggleButton.centerYAnchor)
        ])
    }
    
}
