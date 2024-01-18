//
//  SummaryInformationView.swift
//  KCS
//
//  Created by 김영현 on 1/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SummaryInformationView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private lazy var storeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = UIColor.primary2
        
        return label
    }()
    
    private lazy var certificationStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillProportionally
        
        return stack
    }()
    
    private lazy var categoty: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.kcsGray
        
        return label
    }()
    
    private let storeOpenClosed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.goodPrice
        
        return label
    }()
    
    private let openingHour: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.kcsGray
        
        return label
    }()
    
    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let storeCallButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.image = SystemImage.phone
        config.cornerStyle = .capsule
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        
        return button
    }()
    
    private let dismissIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.swipeBar
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        setBackgroundColor()
        setLayerShadow(shadowOffset: .zero)
        setLayerCorner(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SummaryInformationView {
    
    func setBackgroundColor() {
        backgroundColor = .white
    }
    
    func addUIComponents() {
        addSubview(storeTitle)
        addSubview(certificationStackView)
        addSubview(categoty)
        addSubview(storeOpenClosed)
        addSubview(openingHour)
        addSubview(storeImageView)
        addSubview(storeCallButton)
        addSubview(dismissIndicatorView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            storeTitle.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            storeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            certificationStackView.topAnchor.constraint(equalTo: storeTitle.bottomAnchor, constant: 10),
            certificationStackView.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            categoty.centerYAnchor.constraint(equalTo: storeTitle.centerYAnchor, constant: 2),
            categoty.leadingAnchor.constraint(equalTo: storeTitle.trailingAnchor, constant: 4)
        ])
        
        NSLayoutConstraint.activate([
            storeOpenClosed.topAnchor.constraint(equalTo: certificationStackView.bottomAnchor, constant: 16),
            storeOpenClosed.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            openingHour.centerYAnchor.constraint(equalTo: storeOpenClosed.centerYAnchor),
            openingHour.leadingAnchor.constraint(equalTo: storeOpenClosed.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            storeCallButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -49),
            storeCallButton.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor),
            storeCallButton.widthAnchor.constraint(equalToConstant: 69),
            storeCallButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            storeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            storeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            storeImageView.widthAnchor.constraint(equalToConstant: 116),
            storeImageView.heightAnchor.constraint(equalToConstant: 116)
        ])
        
        NSLayoutConstraint.activate([
            dismissIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 35),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
}

extension SummaryInformationView {
    
    func setUIContents(store: Store) {
        storeTitle.text = store.title
        categoty.text = store.category
        let subviews = certificationStackView.arrangedSubviews
        certificationStackView.arrangedSubviews.forEach { certificationStackView.removeArrangedSubview($0) }
        subviews.forEach { $0.removeFromSuperview() }
        store.certificationTypes
            .map({
                CertificationLabel(certificationType: $0)
            })
            .forEach {
                certificationStackView.addArrangedSubview($0)
            }
        if !store.openingHour.isEmpty {
            let openHours = store.openingHour.filter({ $0.open.day.index == Date().weekDay })
            if openHours.isEmpty {
                storeOpenClosed.text = OpenClosedType.closed.rawValue
                openingHour.text = ""
            } else {
                let openingHourString = openingHourString(regularOpeningHours: openHours)
                storeOpenClosed.text = isOpen(open: openingHourString[0], close: openingHourString[1])
                openingHour.text = "\(openingHourString[0]) - \(openingHourString[1])"
            }
        } else {
            storeOpenClosed.text = OpenClosedType.none.rawValue
            openingHour.text = ""
        }
        
        if let phoneNum = store.phoneNumber {
            storeCallButton.rx.tap
                .bind { [weak self] _ in
                    self?.callButtonTapped(phoneNum: phoneNum)
                }
                .disposed(by: disposeBag)
        }
    }
    
}

private extension SummaryInformationView {
    
    func isOpen(open: String, close: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "HH:mm"
        let now = Date().toSecond()
        let close = dateformat.date(from: close)?.toSecond() ?? 86400
        if let open = dateformat.date(from: open)?.toSecond() {
            if open <= now && close >= now {
                return OpenClosedType.open.rawValue
            } else {
                return OpenClosedType.closing.rawValue
            }
        }
        return OpenClosedType.none.rawValue
    }
    
    func openingHourString(regularOpeningHours: [RegularOpeningHours]) -> [String] {
        var openingHourStrings: [String] = []
        if let openHour = regularOpeningHours.first?.open.hour,
           let openMin = regularOpeningHours.first?.open.minute {
            openingHourStrings.append(String(format: "%02d:%02d", openHour, openMin))
        }
        if let closeHour = regularOpeningHours.last?.close.hour,
           let closeMin = regularOpeningHours.last?.close.minute {
            if closeHour == 0 {
                openingHourStrings.append(String(format: "%02d:%02d", 24, closeMin))
            } else {
                openingHourStrings.append(String(format: "%02d:%02d", closeHour, closeMin))
            }
        }
        return openingHourStrings
    }
    
    func callButtonTapped(phoneNum: String) {
        if let url = URL(string: "tel://" + "\(phoneNum.filter { $0.isNumber })") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
