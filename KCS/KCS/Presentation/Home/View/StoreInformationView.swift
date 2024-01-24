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
        
        addUIComponents()
        configureConstraints()
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
        summaryView.isHidden = false
        summaryView.isHidden = true
    }
    
    func changeToDetail() {
        summaryView.isHidden = true
        summaryView.isHidden = false
    }
    
}

private extension StoreInformationView {
    
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
