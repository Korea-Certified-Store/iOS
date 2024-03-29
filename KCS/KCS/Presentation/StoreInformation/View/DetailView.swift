//
//  DetailView.swift
//  KCS
//
//  Created by 조성민 on 1/24/24.
//

import UIKit
import RxSwift
import RxRelay

final class DetailView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private lazy var storeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 22, weight: .bold)
        label.textColor = UIColor.primary1
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var category: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 13, weight: .regular)
        label.textColor = UIColor.kcsGray1
        
        return label
    }()
    
    private lazy var certificationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let divideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.kcsGray3
        
        return view
    }()
    
    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setLayerCorner(cornerRadius: 6)
        imageView.clipsToBounds = true
        imageView.image = UIImage.basicStore
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let clockIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage.clockIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var storeOpenClosed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 13, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var openingHour: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 12, weight: .regular)
        label.textColor = UIColor.kcsGray1
        
        return label
    }()
    
    private let openingHoursStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let phoneIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage.phoneIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let phoneNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 13, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    private let addressIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage.addressIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let address: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 13, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var updateReqeustButton: UIButton = {
        let title = "잘못된 정보 제보하기"
        var attributedTitle = NSMutableAttributedString(string: title)
        attributedTitle.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: title.count)
        )
        attributedTitle.addAttribute(
            .font, 
            value: UIFont.pretendard(size: 11, weight: .medium),
            range: NSRange(location: 0, length: title.count)
        )
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.kcsGray1, for: .normal)
        button.titleLabel?.attributedText = attributedTitle
        
        button.rx.tap
            .bind { [weak self] _ in
                self?.updateReqeustButtonObserver.accept(())
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private let updateReqeustButtonObserver: PublishRelay<Void>
    
    private lazy var addressConstraint = address.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
    private lazy var phoneNumberConstraint = phoneNumber.topAnchor.constraint(equalTo: openingHoursStackView.bottomAnchor, constant: 20)
    
    init(updateReqeustButtonObserver: PublishRelay<Void>) {
        self.updateReqeustButtonObserver = updateReqeustButtonObserver
        super.init(frame: .zero)
        
        setBackgroundColor()
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension DetailView {
    
    func setBackgroundColor() {
        backgroundColor = .white
    }
    
    func addUIComponents() {
        addSubview(storeTitle)
        addSubview(category)
        addSubview(certificationStackView)
        addSubview(divideView)
        addSubview(storeImageView)
        addSubview(clockIcon)
        addSubview(storeOpenClosed)
        addSubview(openingHour)
        addSubview(openingHoursStackView)
        addSubview(phoneIcon)
        addSubview(phoneNumber)
        addSubview(addressIcon)
        addSubview(address)
        addSubview(updateReqeustButton)
    }
    
    func configureConstraints() {
        storeRepresentConstraints()
        openingHourConstraints()
        phoneConstraints()
        addressConstraints()
        updateReqeustButtonConstraints()
    }
    
    func storeRepresentConstraints() {
        NSLayoutConstraint.activate([
            storeTitle.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            storeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            storeTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            category.topAnchor.constraint(equalTo: storeTitle.bottomAnchor, constant: 4),
            category.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            certificationStackView.topAnchor.constraint(equalTo: category.bottomAnchor, constant: 9),
            certificationStackView.leadingAnchor.constraint(equalTo: storeTitle.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divideView.topAnchor.constraint(equalTo: certificationStackView.bottomAnchor, constant: 20),
            divideView.leadingAnchor.constraint(equalTo: leadingAnchor),
            divideView.trailingAnchor.constraint(equalTo: trailingAnchor),
            divideView.heightAnchor.constraint(equalToConstant: 6)
        ])
        
        NSLayoutConstraint.activate([
            storeImageView.topAnchor.constraint(equalTo: divideView.bottomAnchor, constant: 16),
            storeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            storeImageView.widthAnchor.constraint(equalToConstant: 150),
            storeImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func openingHourConstraints() {
        NSLayoutConstraint.activate([
            clockIcon.centerYAnchor.constraint(equalTo: storeOpenClosed.centerYAnchor),
            clockIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            clockIcon.heightAnchor.constraint(equalToConstant: 14),
            clockIcon.widthAnchor.constraint(equalToConstant: 14)
        ])
        
        NSLayoutConstraint.activate([
            storeOpenClosed.topAnchor.constraint(equalTo: divideView.bottomAnchor, constant: 16),
            storeOpenClosed.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            openingHour.bottomAnchor.constraint(equalTo: storeOpenClosed.bottomAnchor),
            openingHour.leadingAnchor.constraint(equalTo: storeOpenClosed.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            openingHoursStackView.topAnchor.constraint(equalTo: storeOpenClosed.bottomAnchor, constant: 8),
            openingHoursStackView.leadingAnchor.constraint(equalTo: storeOpenClosed.leadingAnchor)
        ])
    }
    
    func phoneConstraints() {
        NSLayoutConstraint.activate([
            phoneIcon.centerYAnchor.constraint(equalTo: phoneNumber.centerYAnchor),
            phoneIcon.leadingAnchor.constraint(equalTo: clockIcon.leadingAnchor),
            phoneIcon.heightAnchor.constraint(equalToConstant: 14),
            phoneIcon.widthAnchor.constraint(equalToConstant: 13)
        ])
        
        NSLayoutConstraint.activate([
            phoneNumber.leadingAnchor.constraint(equalTo: phoneIcon.trailingAnchor, constant: 11),
            phoneNumberConstraint
        ])
    }
    
    func addressConstraints() {
        NSLayoutConstraint.activate([
            addressIcon.topAnchor.constraint(equalTo: address.topAnchor),
            addressIcon.leadingAnchor.constraint(equalTo: clockIcon.leadingAnchor),
            addressIcon.heightAnchor.constraint(equalToConstant: 16),
            addressIcon.widthAnchor.constraint(equalToConstant: 11)
        ])
        
        NSLayoutConstraint.activate([
            address.topAnchor.constraint(equalTo: phoneNumber.bottomAnchor, constant: 20),
            address.leadingAnchor.constraint(equalTo: addressIcon.trailingAnchor, constant: 13),
            addressConstraint
        ])
    }
    
    func updateReqeustButtonConstraints() {
        NSLayoutConstraint.activate([
            updateReqeustButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            updateReqeustButton.topAnchor.constraint(equalTo: storeImageView.bottomAnchor, constant: 274)
        ])
    }
    
}

extension DetailView {
    
    func setUIContents(contents: DetailViewContents) {
        storeTitle.text = contents.storeTitle
        category.text = contents.category
        contents.certificationTypes
            .map({
                CertificationLabel(certificationType: $0)
            })
            .forEach { [weak self] in
                self?.certificationStackView.addArrangedSubview($0)
            }
        address.text = contents.address
        phoneNumber.text = contents.phoneNumber
        
        var detailOpeningHours = contents.detailOpeningHour
        if detailOpeningHours.isEmpty { return }
        let today = detailOpeningHours.removeFirst()
        openingHoursStackView.addArrangedSubview(
            OpeningHoursCellView(
                weekday: today.weekDay,
                openingHour: today.openingHour,
                isToday: true
            )
        )
        detailOpeningHours.forEach { [weak self] detailOpeningHour in
            self?.openingHoursStackView.addArrangedSubview(
                OpeningHoursCellView(
                    weekday: detailOpeningHour.weekDay,
                    openingHour: detailOpeningHour.openingHour
                )
            )
        }
    }
    
    func setThumbnailImage(imageData: Data) {
        storeImageView.image = UIImage(data: imageData)
    }
    
    func setOpeningHour(openClosedContent: OpenClosedContent) {
        storeOpenClosed.text = openClosedContent.openClosedType.description
        storeOpenClosed.textColor = UIColor.goodPrice
        openingHour.text = openClosedContent.nextOpeningHour
        addressConstraint.constant = -16
        phoneNumberConstraint.constant = 20
    }
    
    func setNoOpeningHour() {
        storeOpenClosed.text = "영업시간 정보 없음"
        storeOpenClosed.textColor = .black
        openingHour.text = OpenClosedType.none.rawValue
        addressConstraint.constant = -174
        phoneNumberConstraint.constant = 20 - 11
    }
    
    func resetUIContents() {
        storeTitle.text = nil
        category.text = nil
        address.text = nil
        phoneNumber.text = nil
        storeOpenClosed.text = nil
        openingHour.text = nil
        storeImageView.image = UIImage.basicStore
        certificationStackView.clear()
        openingHoursStackView.clear()
    }
}
