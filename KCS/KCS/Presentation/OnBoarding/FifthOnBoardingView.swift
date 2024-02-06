//
//  FifthOnBoardingView.swift
//  KCS
//
//  Created by 김영현 on 2/6/24.
//

import UIKit

final class FifthOnBoardingView: UIView {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나인가 시작하기"
        label.font = UIFont.pretendard(size: 24, weight: .bold)
        label.textColor = .primary1
        label.textAlignment = .center
        
        return label
    }()
    
    private let centerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.onBoarding5)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이젠 정말 나인가와 함께 할 시간이에요!"
        label.font = UIFont.pretendard(size: 19, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension FifthOnBoardingView {
    
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
            centerImageView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 73)
        ])
        
        NSLayoutConstraint.activate([
            bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 93)
        ])
    }
    
}
