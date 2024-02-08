//
//  OpeningHoursCellView.swift
//  KCS
//
//  Created by 김영현 on 1/25/24.
//

import UIKit

final class OpeningHoursCellView: UIView {
    
    private let weekday: Day
    private let openingHour: OpeningHour
    private let isToday: Bool
    
    private lazy var weekdayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = weekday.description
        label.textColor = .black
        if isToday {
            label.font = UIFont.pretendard(size: 13, weight: .medium)
        } else {
            label.font = UIFont.pretendard(size: 13, weight: .regular)
        }
        
        return label
    }()
    
    private lazy var openingHourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = openingHour.openingHour
        label.textColor = .black
        if isToday {
            label.font = UIFont.pretendard(size: 12, weight: .medium)
        } else {
            label.font = UIFont.pretendard(size: 12, weight: .regular)
        }
        
        return label
    }()
    
    private lazy var breakTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = openingHour.breakTime
        label.textColor = .black
        if isToday {
            label.font = UIFont.pretendard(size: 12, weight: .medium)
        } else {
            label.font = UIFont.pretendard(size: 12, weight: .regular)
        }
        
        return label
    }()
    
    init(weekday: Day, openingHour: OpeningHour, isToday: Bool = false) {
        self.weekday = weekday
        self.openingHour = openingHour
        self.isToday = isToday
        super.init(frame: .zero)
        
        addUIComponents()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension OpeningHoursCellView {
    
    func addUIComponents() {
        addSubview(weekdayLabel)
        addSubview(openingHourLabel)
        addSubview(breakTimeLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            weekdayLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekdayLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            openingHourLabel.bottomAnchor.constraint(equalTo: weekdayLabel.bottomAnchor),
            openingHourLabel.leadingAnchor.constraint(equalTo: weekdayLabel.trailingAnchor, constant: 5)
        ])
        
        NSLayoutConstraint.activate([
            breakTimeLabel.topAnchor.constraint(equalTo: openingHourLabel.bottomAnchor),
            breakTimeLabel.leadingAnchor.constraint(equalTo: openingHourLabel.leadingAnchor),
            breakTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
