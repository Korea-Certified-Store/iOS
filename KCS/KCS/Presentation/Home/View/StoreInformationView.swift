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
    
    init(summaryViewModel: SummaryInformationViewModel, summaryInformationHeightObserver: PublishRelay<CGFloat>) {
        self.summaryViewModel = summaryViewModel
        self.summaryInformationHeightObserver = summaryInformationHeightObserver
        super.init(frame: .zero)
        
//        setLayerCorner(cornerRadius: 15, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
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
    }
    
}

private extension StoreInformationView {
    
    func addUIComponents() {
        addSubview(summaryView)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: topAnchor),
            summaryView.bottomAnchor.constraint(equalTo: bottomAnchor),
            summaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
}
