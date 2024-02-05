//
//  StoreListViewController.swift
//  KCS
//
//  Created by 조성민 on 1/31/24.
//

import UIKit
import RxSwift
import RxRelay

final class StoreListViewController: UIViewController {
    
    private let cellSelectedIndexObserver: PublishRelay<Int>
    
    private let disposeBag = DisposeBag()
    
    private let titleBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let titleItem = UINavigationItem(title: "가게 모아보기")
        navigationBar.setItems([titleItem], animated: true)
        navigationBar.backgroundColor = .white
        navigationBar.isTranslucent = false
        
        return navigationBar
    }()
    
    private let storeTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 109
        tableView.register(StoreTableViewCell.self, forCellReuseIdentifier: StoreTableViewCell.identifier)
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    enum Section {
        case store
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, StoreTableViewCellContents> = {
        return UITableViewDiffableDataSource<Section, StoreTableViewCellContents>(
            tableView: storeTableView
        ) { (tableView, indexPath, storeContents) in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoreTableViewCell.identifier,
                for: indexPath
            ) as? StoreTableViewCell else {
                return StoreTableViewCell()
            }
            cell.setUIContents(storeContents: storeContents)
            
            return cell
        }
    }()
    
    private let viewModel: StoreListViewModel
    
    init(viewModel: StoreListViewModel, cellSelectedIndexObserver: PublishRelay<Int>) {
        self.viewModel = viewModel
        self.cellSelectedIndexObserver = cellSelectedIndexObserver
        
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
    
    func updateList(stores: [Store]) {
        viewModel.action(input: .updateList(stores: stores))
    }
    
}

private extension StoreListViewController {
    
    func setup() {
        isModalInPresentation = true
        storeTableView.delegate = self
    }
    
    func addUIComponents() {
        view.addSubview(storeTableView)
        view.addSubview(titleBar)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            titleBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            storeTableView.topAnchor.constraint(equalTo: titleBar.bottomAnchor),
            storeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            storeTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            storeTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func bind() {
        viewModel.updateListOutput
            .bind { [weak self] contentsArray in
                guard let self = self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<Section, StoreTableViewCellContents>()
                snapshot.appendSections([.store])
                snapshot.appendItems(contentsArray, toSection: Section.store)
                dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
    }
    
}

extension StoreListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelectedIndexObserver.accept(indexPath.row)
    }
    
}
