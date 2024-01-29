//
//  RefreshButton.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import UIKit

final class RefreshButton: UIButton {

    private var animationTimer: Timer?
    
    init() {
        super.init(frame: .zero)
        setUI()
        setLayerShadow(shadowOffset: CGSize(width: 0, height: 2))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationFire() {
        isUserInteractionEnabled = false
        var imageIndex = 0
        var config = configuration
        config?.attributedTitle = nil
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let images = [
                UIImage.refreshAnimation1,
                UIImage.refreshAnimation2,
                UIImage.refreshAnimation3,
                UIImage.refreshAnimation4,
                UIImage.refreshAnimation5
            ]
            config?.image = images[imageIndex]
            self.configuration = config
            
            imageIndex = (imageIndex + 1) % 5
        }
    }
    
    func animationInvalidate() {
        isUserInteractionEnabled = true
        isHidden = true
        animationTimer?.invalidate()
        
        var titleAttribute = AttributedString("현 지도에서 검색")
        titleAttribute.font = UIFont.pretendard(size: 10, weight: .medium)
        configuration?.attributedTitle = titleAttribute
        configuration?.image = SystemImage.refresh?.withTintColor(.primary3, renderingMode: .alwaysOriginal)
    }
    
}

private extension RefreshButton {
    
    func setUI() {
        var titleAttribute = AttributedString("현 지도에서 검색")
        titleAttribute.font = UIFont.pretendard(size: 10, weight: .medium)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttribute
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.image = SystemImage.refresh?.withTintColor(.primary3, renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10)
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 10, bottom: 11, trailing: 10)
        configuration = config
    }
    
}
