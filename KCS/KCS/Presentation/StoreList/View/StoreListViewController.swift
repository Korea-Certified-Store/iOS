//
//  StoreListViewController.swift
//  KCS
//
//  Created by 조성민 on 1/31/24.
//

import UIKit
import RxSwift

final class StoreListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
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
    
    init(viewModel: StoreListViewModel) {
        self.viewModel = viewModel
        
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
    }
    
    func updateList(stores: [Store]) {
        viewModel.action(input: .updateList(stores: stores))
    }
    
}

private extension StoreListViewController {
    
    func addUIComponents() {
        view.addSubview(storeTableView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            storeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
