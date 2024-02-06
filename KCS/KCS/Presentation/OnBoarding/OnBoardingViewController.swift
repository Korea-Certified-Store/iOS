//
//  OnBoardingViewController.swift
//  KCS
//
//  Created by 김영현 on 2/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class OnBoardingViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let onBoardingViews: [UIView] = [
        FirstOnBoardingView(),
        SecondOnBoardingView(),
        ThirdOnBoardingView(),
        FourthOnBoardingView(),
        FifthOnBoardingView()
    ]
    
    private lazy var onBoardingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(onBoardingViews.count),
            height: scrollView.bounds.height
        )
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        
        onBoardingViews.forEach { view in
            scrollView.addSubview(view)
        }
        
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .swipeBar
        pageControl.currentPageIndicatorTintColor = .primary1
        pageControl.numberOfPages = onBoardingViews.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        
        return pageControl
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = UIFont.pretendard(size: 16, weight: .medium)
        button.titleLabel?.textColor = .white
        button.setLayerCorner(cornerRadius: 6)
        button.backgroundColor = .primary1
        button.isHidden = true
        button.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                UserDefaults.standard.set(false, forKey: "executeOnBoarding")
                homeViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                present(homeViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private let homeViewController: HomeViewController
    
    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addUIComponents()
        configureConstraints()
    }
    
}

private extension OnBoardingViewController {
    
    func setup() {
        view.backgroundColor = .white
    }
    
    func addUIComponents() {
        view.addSubview(onBoardingScrollView)
        view.addSubview(pageControl)
        view.addSubview(startButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            onBoardingScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 53),
            onBoardingScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            onBoardingScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            onBoardingScrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: 50)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -99),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            onBoardingViews[0].leadingAnchor.constraint(equalTo: onBoardingScrollView.leadingAnchor),
            onBoardingViews[0].bottomAnchor.constraint(equalTo: onBoardingScrollView.bottomAnchor),
            onBoardingViews[0].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        
        NSLayoutConstraint.activate([
            onBoardingViews[1].leadingAnchor.constraint(equalTo: onBoardingViews[0].trailingAnchor),
            onBoardingViews[1].bottomAnchor.constraint(equalTo: onBoardingScrollView.bottomAnchor),
            onBoardingViews[1].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        
        NSLayoutConstraint.activate([
            onBoardingViews[2].leadingAnchor.constraint(equalTo: onBoardingViews[1].trailingAnchor),
            onBoardingViews[2].bottomAnchor.constraint(equalTo: onBoardingScrollView.bottomAnchor),
            onBoardingViews[2].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        
        NSLayoutConstraint.activate([
            onBoardingViews[3].leadingAnchor.constraint(equalTo: onBoardingViews[2].trailingAnchor),
            onBoardingViews[3].bottomAnchor.constraint(equalTo: onBoardingScrollView.bottomAnchor),
            onBoardingViews[3].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        
        NSLayoutConstraint.activate([
            onBoardingViews[4].leadingAnchor.constraint(equalTo: onBoardingViews[3].trailingAnchor),
            onBoardingViews[4].bottomAnchor.constraint(equalTo: onBoardingScrollView.bottomAnchor),
            onBoardingViews[4].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
}

extension OnBoardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        
        if pageControl.currentPage == onBoardingViews.count - 1 {
            startButton.isHidden = false
        } else {
            startButton.isHidden = true
        }
    }
    
}
