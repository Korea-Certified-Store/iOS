//
//  SplashViewController.swift
//  KCS
//
//  Created by 김영현 on 2/8/24.
//

import RxSwift
import RxRelay

final class SplashViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.kcsLogo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let disposeBag = DisposeBag()
    let viewModel: SplashViewModel
    let mainNavigationController: UINavigationController
    
    init(viewModel: SplashViewModel, mainNavigationController: UINavigationController) {
        self.viewModel = viewModel
        self.mainNavigationController = mainNavigationController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        bind()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.input(action: .checkNetworkInput)
    }
    
}

private extension SplashViewController {
    
    func setup() {
        view.backgroundColor = .white
    }
    
    func bind() {
        viewModel.networkEnableOutput
            .bind { [weak self] in
                guard let self = self else { return }
                mainNavigationController.modalPresentationStyle = .fullScreen
                present(mainNavigationController, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.networkDisableOutput
            .bind { [weak self] in
                self?.presentNetworkAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func presentNetworkAlert() {
        let alertController = UIAlertController(
            title: "네트워크 상태 확인",
            message: "네트워크가 불안정 합니다.",
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(
            title: "다시 시도",
            style: .default
        ) { [weak self] _ in
            self?.viewModel.input(action: .checkNetworkInput)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
}

private extension SplashViewController {
    
    func addUIComponents() {
        view.addSubview(logoImageView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 94/156.45)
        ])
    }
    
}
