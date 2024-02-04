//
//  MoreStoreButton.swift
//  KCS
//
//  Created by 김영현 on 2/4/24.
//

import UIKit

final class MoreStoreButton: UIButton {
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            if isUserInteractionEnabled {
                configuration?.baseForegroundColor = .black
            } else {
                configuration?.baseForegroundColor = .grayLabel
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        setLayerShadow(shadowOffset: CGSize(width: 0, height: 2))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFetchCount(fetchCount: FetchCountContent) {
        var titleAttribute = AttributedString(String(format: "결과 더보기 %d/%d", fetchCount.fetchCount, fetchCount.maxFetchCount))
        titleAttribute.font = UIFont.pretendard(size: 10, weight: .medium)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = titleAttribute
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 10, bottom: 11, trailing: 10)
        configuration = config
    }
    
}
