//
//  OnboardingViewController.swift
//  KCS
//
//  Created by 김영현 on 2/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let onboardingViews: [UIView] = [
        FirstOnboardingView(),
        SecondOnboardingView(),
        ThirdOnboardingView(),
        FourthOnboardingView(),
        FifthOnboardingView()
    ]
    
    private lazy var onboardingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(onboardingViews.count),
            height: scrollView.bounds.height
        )
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        
        onboardingViews.forEach { view in
            scrollView.addSubview(view)
        }
        
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .kcsGray2
        pageControl.currentPageIndicatorTintColor = .primary1
        pageControl.numberOfPages = onboardingViews.count
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
            .debounce(.milliseconds(100), scheduler: MainScheduler())
            .bind { [weak self] in
                guard let self = self else { return }
                UserDefaults.standard.set(false, forKey: "executeOnboarding")
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

private extension OnboardingViewController {
    
    func setup() {
        view.backgroundColor = .white
    }
    
    func addUIComponents() {
        view.addSubview(onboardingScrollView)
        view.addSubview(pageControl)
        view.addSubview(startButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            onboardingScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 53),
            onboardingScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            onboardingScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            onboardingScrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: 50)
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
            onboardingViews[0].leadingAnchor.constraint(equalTo: onboardingScrollView.leadingAnchor),
            onboardingViews[0].bottomAnchor.constraint(equalTo: onboardingScrollView.bottomAnchor),
            onboardingViews[0].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        
        NSLayoutConstraint.activate([
            onboardingViews[1].leadingAnchor.constraint(equalTo: onboardingViews[0].trailingAnchor),
            onboardingViews[1].bottomAnchor.constraint(equalTo: onboardingScrollView.bottomAnchor),
            onboardingViews[1].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        
        NSLayoutConstraint.activate([
            onboardingViews[2].leadingAnchor.constraint(equalTo: onboardingViews[1].trailingAnchor),
            onboardingViews[2].bottomAnchor.constraint(equalTo: onboardingScrollView.bottomAnchor),
            onboardingViews[2].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        
        NSLayoutConstraint.activate([
            onboardingViews[3].leadingAnchor.constraint(equalTo: onboardingViews[2].trailingAnchor),
            onboardingViews[3].bottomAnchor.constraint(equalTo: onboardingScrollView.bottomAnchor),
            onboardingViews[3].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
        
        NSLayoutConstraint.activate([
            onboardingViews[4].leadingAnchor.constraint(equalTo: onboardingViews[3].trailingAnchor),
            onboardingViews[4].bottomAnchor.constraint(equalTo: onboardingScrollView.bottomAnchor),
            onboardingViews[4].widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
}

extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        
        if pageControl.currentPage == onboardingViews.count - 1 {
            startButton.isHidden = false
        } else {
            startButton.isHidden = true
        }
    }
    
}
