//
//  RefreshButton.swift
//  KCS
//
//  Created by 조성민 on 1/15/24.
//

import UIKit

final class RefreshButton: UIButton {

    init() {
        super.init(frame: .zero)
        setUI()
        setLayerShadow(shadowOffset: CGSize(width: 0, height: 2))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension RefreshButton {
    
    func setUI() {
        var titleAttribute = AttributedString("현 지도에서 검색")
        titleAttribute.font = UIFont.pretendard(size: 10, weight: .medium)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttribute
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .label
        config.image = SystemImage.refresh?.withTintColor(.primary3, renderingMode: .alwaysOriginal)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10)
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 10, bottom: 11, trailing: 10)
        configuration = config
    }
    
}
