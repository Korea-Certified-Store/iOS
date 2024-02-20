//
//  RefreshButton.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import UIKit
import Lottie

final class RefreshButton: UIButton {

    private var animationTimer: Timer?
    
    private let originalTitle: AttributedString
    
    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "RefreshAnimation")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
        animationView.isHidden = true
        
        return animationView
    }()
    
    init(attributedTitle: AttributedString) {
        self.originalTitle = attributedTitle
        super.init(frame: .zero)
        
        addUIComponents()
        configureConstraints()
        setUI()
        setLayerShadow(shadowOffset: CGSize(width: 0, height: 2))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationFire() {
        isUserInteractionEnabled = false
        configuration?.attributedTitle = nil
        configuration?.image = nil
        animationView.isHidden = false
        animationView.play()
    }
    
    func animationInvalidate() {
        isUserInteractionEnabled = true
        animationView.stop()
        animationView.isHidden = true
        configuration?.attributedTitle = originalTitle
        configuration?.image = SystemImage.refresh?.withTintColor(.primary3, renderingMode: .alwaysOriginal)
    }
    
}

private extension RefreshButton {
    
    func setUI() {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = originalTitle
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.image = SystemImage.refresh?.withTintColor(.primary3, renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 11)
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 10, bottom: 11, trailing: 10)
        configuration = config
    }
    
    func addUIComponents() {
        addSubview(animationView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 45),
            animationView.heightAnchor.constraint(equalToConstant: 20),
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
