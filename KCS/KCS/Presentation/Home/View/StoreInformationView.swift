//
//  StoreInformationView.swift
//  KCS
//
//  Created by 김영현 on 1/24/24.
//

import UIKit
import RxRelay

final class StoreInformationView: UIView {
    
    private lazy var summaryView: SummaryInformationView = {
        let view = SummaryInformationView(
            viewModel: summaryViewModel,
            summaryInformationHeightObserver: summaryInformationHeightObserver
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let summaryViewModel: SummaryInformationViewModel
    private let summaryInformationHeightObserver: PublishRelay<CGFloat>
    
    private lazy var detailView: DetailView = {
        let view = DetailView(viewModel: detailViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let detailViewModel: DetailViewModel
    
    init(
        summaryViewModel: SummaryInformationViewModel,
        summaryInformationHeightObserver: PublishRelay<CGFloat>,
        detailViewModel: DetailViewModel
    ) {
        self.summaryViewModel = summaryViewModel
        self.summaryInformationHeightObserver = summaryInformationHeightObserver
        self.detailViewModel = detailViewModel
        super.init(frame: .zero)
        
        setBackgroundColor()
        addUIComponents()
        configureConstraints()
        changeToSummary()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StoreInformationView {
    
    func setUIContents(store: Store) {
        summaryView.setUIContents(store: store)
        detailView.setUIContents(store: store)
    }
    
    func changeToSummary() {
        summaryView.isUserInteractionEnabled = true
        detailView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.summaryView.alpha = 1
            self?.detailView.alpha = 0
        }
    }
    
    func changeToDetail() {
        summaryView.isUserInteractionEnabled = false
        detailView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.summaryView.alpha = 0
            self?.detailView.alpha = 1
        }
    }
    
    func dismissAll() {
        summaryView.isUserInteractionEnabled = false
        detailView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.summaryView.alpha = 0
            self?.detailView.alpha = 0
        }
    }
    
}

private extension StoreInformationView {
    
    func setBackgroundColor() {
        backgroundColor = .white
    }
    
    func addUIComponents() {
        addSubview(summaryView)
        addSubview(detailView)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: topAnchor),
            summaryView.bottomAnchor.constraint(equalTo: bottomAnchor),
            summaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: topAnchor),
            detailView.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
}
