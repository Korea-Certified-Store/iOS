//
//  FirstOnboardingView.swift
//  KCS
//
//  Created by 김영현 on 2/6/24.
//

import UIKit

final class FirstOnboardingView: UIView {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "인증제 별 가게 위치를\n 지도로 한 눈에 알아봐요!"
        label.font = UIFont.pretendard(size: 24, weight: .bold)
        label.textColor = .primary1
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    private let centerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.onboarding1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "여기서 잠깐,\n 인증제에 대해 설명해드릴게요"
        label.font = UIFont.pretendard(size: 19, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        
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

private extension FirstOnboardingView {
    
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
            centerImageView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 79)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 52)
        ])
    }
    
}
