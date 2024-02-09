//
//  SearchViewController.swift
//  KCS
//
//  Created by 조성민 on 2/8/24.
//

import UIKit
import RxSwift
import RxRelay

final class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: SystemImage.back, style: .plain, target: nil, action: nil)
        button.tintColor = .primary3
        button.rx.tap
            .bind { [weak self] _ in
                self?.navigationController?.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색어를 입력하세요"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        return searchController
    }()
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.backgroundColor = .white
        // TODO: 디자인에 맞춰야 함
        tableView.rowHeight = 50
        
        return tableView
    }()
    
    // TODO: Section 별로 layout 따로 구현
    enum Section {
        case autoCompleteKeyword
        case recentSearchKeyword
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, String> = {
        return UITableViewDiffableDataSource<Section, String>(
            tableView: searchTableView
        ) { (tableView, indexPath, keyword) in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: UITableViewCell.identifier,
                for: indexPath
            )
            cell.selectionStyle = .none
            var configuration = cell.defaultContentConfiguration()
            configuration.text = keyword
            cell.contentConfiguration = configuration
            
            return cell
        }
    }()
    
    private let searchObserver: PublishRelay<String>
    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel, searchObserver: PublishRelay<String>) {
        self.viewModel = viewModel
        self.searchObserver = searchObserver
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.action(input: .viewWillAppear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.searchBar.becomeFirstResponder()
    }
    
    func setSearchKeyword(keyword: String?) {
        searchController.searchBar.searchTextField.text = keyword
    }

}

private extension SearchViewController {
    
    func setup() {
        view.backgroundColor = .white
        searchController.isActive = true
    }
    
    func addUIComponents() {
        view.addSubview(searchTableView)
        navigationItem.setLeftBarButton(backButton, animated: true)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func bind() {
        viewModel.generateDataOutput
            .bind { [weak self] data in
                self?.generateData(data: data)
            }
            .disposed(by: disposeBag)
        
        viewModel.recentSearchKeywordsOutput
            .bind { [weak self] keywords in
                let keywordArray = keywords.map { $0.searchKeyword }
                var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
                snapshot.appendSections([.recentSearchKeyword])
                snapshot.appendItems(keywordArray)
                self?.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
    }
    
}

private extension SearchViewController {
    
    func generateData(data: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.autoCompleteKeyword])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.action(input: .textChanged(text: text))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        searchObserver.accept(text)
        viewModel.action(input: .searchButtonTapped(text: text))
        navigationController?.dismiss(animated: false)
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    // TODO: 최근 검색어 삭제 action 필요
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let text = dataSource.itemIdentifier(for: indexPath) else { return }
        self.dismiss(animated: true)
        searchObserver.accept(text)
        viewModel.action(input: .searchButtonTapped(text: text))
        navigationController?.dismiss(animated: false)
    }
    
}
