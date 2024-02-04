//
//  MoreStoreButton.swift
//  KCS
//
//  Created by 김영현 on 2/4/24.
//

import UIKit

final class MoreStoreButton: UIButton {
    
    private let originalTitle: AttributedString = {
        var titleAttribute = AttributedString("결과 더보기")
        titleAttribute.font = UIFont.pretendard(size: 10, weight: .medium)
        
        return titleAttribute
    }()
    
    init() {
        super.init(frame: .zero)
        setUI()
        setLayerShadow(shadowOffset: CGSize(width: 0, height: 2))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MoreStoreButton {
    
    func setUI() {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = originalTitle
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 10, bottom: 11, trailing: 10)
        configuration = config
    }
    
}

