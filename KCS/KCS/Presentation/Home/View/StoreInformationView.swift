//
//  StoreInformationView.swift
//  KCS
//
//  Created by 김영현 on 1/24/24.
//

import UIKit

final class StoreInformationView: UIView {
    
    lazy var summaryView: SummaryInformationView = {
        let view = SummaryInformationView(viewModel: self.summaryViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let summaryViewModel: SummaryInformationViewModel
    
    init(summaryViewModel: SummaryInformationViewModel) {
        self.summaryViewModel = summaryViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StoreInformationView {
    
    func addUIComponents() {
        addSubview(summaryView)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            summaryView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            summaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }
    
}

//@objc
//extension StoreInformationView {
//    
//    func customViewDrag(_ recognizer: UIPanGestureRecognizer) {
//        let transition = recognizer.translation(in: summaryView)
//        let height = summaryView.bounds.height - transition.y
//        
//        recognizer.setTranslation(.zero, in: summaryView)
//        
//        if height > 230 && height < 620 {
//            heightConstraint.constant = height
//        }
//        if recognizer.state == .ended {
//            if heightConstraint.constant > 400 {
//                heightConstraint.constant = 600
//            } else {
//                heightConstraint.constant = 250
//            }
//            UIView.animate(withDuration: 0.3) { [weak self] in
//                self?.view.layoutIfNeeded()
//            }
//        }
//    }
//    
//}
