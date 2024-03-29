//
//  StoreInformationViewController.swift
//  KCS
//
//  Created by 조성민 on 2/3/24.
//

import UIKit
import RxRelay
import RxSwift

final class StoreInformationViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private lazy var summaryView: SummaryView = {
        let view = SummaryView(
            summaryViewHeightObserver: summaryViewHeightObserver
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let summaryViewHeightObserver: PublishRelay<SummaryViewHeightCase>
    private let updateReqeustButtonObserver = PublishRelay<Void>()
    
    private lazy var detailView: DetailView = {
        let view = DetailView(updateReqeustButtonObserver: updateReqeustButtonObserver)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let storeUpdateRequestViewController: StoreUpdateRequestViewController
    
    private let viewModel: StoreInformationViewModel
    
    init(
        storeUpdateRequestViewController: StoreUpdateRequestViewController,
        summaryViewHeightObserver: PublishRelay<SummaryViewHeightCase>,
        viewModel: StoreInformationViewModel
    ) {
        self.storeUpdateRequestViewController = storeUpdateRequestViewController
        self.summaryViewHeightObserver = summaryViewHeightObserver
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StoreInformationViewController {
    
    func setup() {
        view.backgroundColor = .white
        isModalInPresentation = true
    }
    
    func bind() {
        viewModel.errorAlertOutput
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] error in
                self?.presentErrorAlert(error: error)
            }
            .disposed(by: disposeBag)
        
        viewModel.thumbnailImageOutput
            .bind { [weak self] imageData in
                self?.summaryView.setThumbnailImage(imageData: imageData)
                self?.detailView.setThumbnailImage(imageData: imageData)
            }
            .disposed(by: disposeBag)
        
        viewModel.summaryCallButtonOutput
            .throttle(.milliseconds(10), latest: false, scheduler: MainScheduler())
            .bind { [weak self] phoneNumber in
                self?.summaryView.setCallButton(phoneNumber: phoneNumber)
            }
            .disposed(by: disposeBag)
        
        viewModel.setSummaryUIContentsOutput
            .bind { [weak self] contents in
                self?.summaryView.setUIContents(contents: contents)
            }
            .disposed(by: disposeBag)
        
        viewModel.setDetailUIContentsOutput
            .bind { [weak self] contents in
                self?.detailView.setUIContents(contents: contents)
            }
            .disposed(by: disposeBag)
        
        viewModel.openClosedContentOutput
            .bind { [weak self] openClosedContent in
                self?.detailView.setOpeningHour(openClosedContent: openClosedContent)
            }
            .disposed(by: disposeBag)
        
        viewModel.noneOpenClosedContentOutput
            .bind { [weak self] in
                self?.detailView.setNoOpeningHour()
            }
            .disposed(by: disposeBag)
        
        updateReqeustButtonObserver
            .bind { [weak self] _ in
                guard let self = self else { return }
                present(storeUpdateRequestViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func setUIContents(store: Store) {
        summaryView.resetUIContents()
        detailView.resetUIContents()
        viewModel.action(input: .setUIContents(store: store))
        storeUpdateRequestViewController.setStoreID(id: store.id)
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
    
}

private extension StoreInformationViewController {
    
    func addUIComponents() {
        view.addSubview(summaryView)
        view.addSubview(detailView)
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: view.topAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
}
