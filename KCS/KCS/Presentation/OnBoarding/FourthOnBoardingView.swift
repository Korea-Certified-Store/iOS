//
//  FourthOnBoardingView.swift
//  KCS
//
//  Created by 김영현 on 2/6/24.
//

import UIKit

final class FourthOnBoardingView: UIView {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "안심식당이란?"
        label.font = UIFont.pretendard(size: 24, weight: .bold)
        label.textColor = .primary1
        label.textAlignment = .center
        
        return label
    }()
    
    private let centerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.onBoarding4)
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
        
        let text = "감염병에 취약한 식사문화 개선을 위해\n덜어먹기, 위생적 수저관리, 종사자 마스크\n착용 및 생활 방역을 준수하는 곳으로\n소재지 지자체의 인증을\n받은 음식점을 의미합니다."
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(
            .font,
            value: UIFont.pretendard(size: 19, weight: .heavy),
            range: (text as NSString).range(of: "덜어먹기, 위생적 수저관리, 종사자 마스크\n착용 및 생활 방역을 준수하는 곳")
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

private extension FourthOnBoardingView {
    
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
