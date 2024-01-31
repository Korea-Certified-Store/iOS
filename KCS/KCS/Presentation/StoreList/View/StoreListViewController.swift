//
//  StoreListViewController.swift
//  KCS
//
//  Created by 조성민 on 1/31/24.
//

import UIKit

final class StoreListViewController: UIViewController {
    
    private let storeTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 109
        
        return tableView
    }()
    
    enum Section {
        case store
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Store> = {
        return UITableViewDiffableDataSource<Section, Store>(tableView: storeTableView) { (tableView, indexPath, store) in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoreTableViewCell.identifier,
                for: indexPath
            ) as? StoreTableViewCell else {
                return StoreTableViewCell()
            }
            cell.setUIContents(store: store)
            
            return cell
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        bind()
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
        
    }
    
}
