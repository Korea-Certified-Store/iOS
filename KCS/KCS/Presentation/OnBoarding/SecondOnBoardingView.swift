//
//  SecondOnBoardingView.swift
//  KCS
//
//  Created by 김영현 on 2/6/24.
//

import UIKit

final class SecondOnBoardingView: UIView {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "착한 가격 업소란?"
        label.font = UIFont.pretendard(size: 24, weight: .bold)
        label.textColor = .primary1
        label.textAlignment = .center
        
        return label
    }()
    
    private let centerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.onBoarding2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let text = "2011년부터 물가안정을 위해\n가격이 저렴하지만 양질의 서비스를\n제공하는 곳을 정부가 지정한\n우리 동네의 좋은 업소입니다."
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(
            .foregroundColor,
            value: UIFont.pretendard(size: 19, weight: .heavy),
            range: (text as NSString).range(of: "가격이 저렴")
        )
        attributeString.addAttribute(
            .foregroundColor,
            value: UIFont.pretendard(size: 19, weight: .heavy),
            range: (text as NSString).range(of: "양질의 서비스")
        )
        
        label.attributedText = attributeString
        label.font = UIFont.pretendard(size: 19, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 4
        
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

private extension SecondOnBoardingView {
    
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
            bottomLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 89)
        ])
    }
    
}
