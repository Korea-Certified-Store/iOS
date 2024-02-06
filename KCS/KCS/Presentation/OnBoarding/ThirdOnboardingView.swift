//
//  ThirdOnBoardingView.swift
//  KCS
//
//  Created by 김영현 on 2/6/24.
//

import UIKit

final class ThirdOnboardingView: UIView {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "모범 음식점이란?"
        label.font = UIFont.pretendard(size: 24, weight: .bold)
        label.textColor = .primary1
        label.textAlignment = .center
        
        return label
    }()
    
    private let centerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.onBoarding3)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 19, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 5
        
        let text = "식품위생법에 근거하여\n위생관리 상태 등이 우수한 업소를\n모범업소로 지정합니다.\n서비스 수준 향상과 위생적 개선을 도모하기\n위해 운영되고 있습니다."
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(
            .font,
            value: UIFont.pretendard(size: 19, weight: .heavy),
            range: (text as NSString).range(of: "위생관리 상태 등이 우수한 업소")
        )
        label.attributedText = attributeString
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ThirdOnboardingView {
    
    func addUIComponents() {
        addSubview(topLabel)
        addSubview(centerImageView)
        addSubview(bottomLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            centerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 83),
            centerImageView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 60)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 67)
        ])
    }
    
}
