//
//  SearchViewController.swift
//  KCS
//
//  Created by 조성민 on 2/8/24.
//

import UIKit
import RxSwift
import RxRelay

// TODO: 키보드 높이에 따른 레이아웃 수정
final class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.plain()
        config.image = .backButton
        config.baseForegroundColor = .kcsGray1
        button.configuration = config
        
        button.rx.tap
            .bind { [weak self] _ in
                self?.dismissViewController()
            }
            .disposed(by: disposeBag)

        return button
    }()
    
    private lazy var searchBarView: SearchBarView = {
        let view = SearchBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.searchTextField.delegate = self
        
        Observable.merge(
            view.searchTextField.rx.text.asObservable(),
            view.searchTextField.rx.observe(String.self, "text")
        )
        .bind { [weak self] text in
            self?.viewModel.action(input: .textChanged(text: text ?? ""))
        }
        .disposed(by: disposeBag)
        
        view.xMarkImageView.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                view.searchTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        view.searchImageView.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                if let text = view.searchTextField.text {
                    self?.search(text: text)
                }
            })
            .disposed(by: disposeBag)
        
        return view
    }()
    
    enum RecentHistorySection {
        case recentHistory
    }
    
    enum AutoCompletionSection {
        case autoCompletion
    }
    
    private lazy var recentHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RecentHistoryTableViewCell.self, forCellReuseIdentifier: RecentHistoryTableViewCell.identifier)
        tableView.register(RecentHistoryHeaderView.self, forHeaderFooterViewReuseIdentifier: RecentHistoryHeaderView.identifier)
        tableView.delegate = self
        tableView.bounces = false
        tableView.sectionHeaderTopPadding = 0
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset = .zero
        
        return tableView
    }()
    
    private lazy var recentHistoryDataSource: UITableViewDiffableDataSource<RecentHistorySection, String> = {
        let dataSource = UITableViewDiffableDataSource<RecentHistorySection, String>(
            tableView: recentHistoryTableView,
            cellProvider: { (tableView, indexPath, keyword) in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: RecentHistoryTableViewCell.identifier
                ) as? RecentHistoryTableViewCell else { return RecentHistoryTableViewCell() }
                cell.setUIContents(keyword: keyword)
                cell.setIndexPath(indexPath: indexPath)
                cell.selectionStyle = .none
                cell.delegate = self
                
                return cell
            }
        )
        
        return dataSource
    }()
    
    private lazy var autoCompletionTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AutoCompletionTableViewCell.self, forCellReuseIdentifier: AutoCompletionTableViewCell.identifier)
        tableView.delegate = self
        tableView.bounces = false
        tableView.sectionHeaderTopPadding = 0
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset = .zero
        
        return tableView
    }()
    
    private lazy var autoCompletionDataSource: UITableViewDiffableDataSource<AutoCompletionSection, String> = {
        let dataSource = UITableViewDiffableDataSource<AutoCompletionSection, String>(
            tableView: autoCompletionTableView,
            cellProvider: { (tableView, _, keyword) in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: AutoCompletionTableViewCell.identifier
                ) as? AutoCompletionTableViewCell else { return AutoCompletionTableViewCell() }
                cell.setUIContents(keyword: keyword)
                cell.selectionStyle = .none
                
                return cell
            }
        )
        
        return dataSource
    }()
    
    private let divideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .kcsGray3
        
        return view
    }()
    
    private let searchObserver: PublishRelay<String>
    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel, searchObserver: PublishRelay<String>) {
        self.viewModel = viewModel
        self.searchObserver = searchObserver
        
        super.init(nibName: nil, bundle: nil)
        setup()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBarView.searchTextField.becomeFirstResponder()
    }
    
    func setSearchKeyword(keyword: String?) {
        searchBarView.searchTextField.text = keyword
    }
    
    func dismissViewController() {
        view.endEditing(true)
        dismiss(animated: false)
    }
    
}

private extension SearchViewController {
    
    func setup() {
        view.backgroundColor = .white
        modalPresentationStyle = .fullScreen
    }
    
    func addUIComponents() {
        view.addSubview(backButton)
        view.addSubview(searchBarView)
        view.addSubview(divideView)
        view.addSubview(recentHistoryTableView)
        view.addSubview(autoCompletionTableView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 10),
            backButton.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            searchBarView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
            searchBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBarView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            divideView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 16),
            divideView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            divideView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            divideView.heightAnchor.constraint(equalToConstant: 6)
        ])
        
        NSLayoutConstraint.activate([
            recentHistoryTableView.topAnchor.constraint(equalTo: divideView.bottomAnchor),
            recentHistoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recentHistoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recentHistoryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            autoCompletionTableView.topAnchor.constraint(equalTo: divideView.bottomAnchor),
            autoCompletionTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            autoCompletionTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            autoCompletionTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func bind() {
        viewModel.recentSearchKeywordsOutput
            .bind { [weak self] keywords in
                self?.recentHistoryTableView.isHidden = false
                self?.autoCompletionTableView.isHidden = true
                self?.generateRecentHistoryData(data: keywords)
            }
            .disposed(by: disposeBag)
        
        viewModel.autoCompleteKeywordsOutput
            .bind { [weak self] keywords in
                self?.recentHistoryTableView.isHidden = true
                self?.autoCompletionTableView.isHidden = false
                self?.generateAutoCompletionData(data: keywords)
            }
            .disposed(by: disposeBag)
    }
    
}

private extension SearchViewController {
    
    // TODO: Reload Data 수정 필요
    func generateRecentHistoryData(data: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<RecentHistorySection, String>()
        snapshot.appendSections([.recentHistory])
        snapshot.appendItems(data)
        recentHistoryDataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    func generateAutoCompletionData(data: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<AutoCompletionSection, String>()
        snapshot.appendSections([.autoCompletion])
        snapshot.appendItems(data)
        autoCompletionDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func search(text: String) {
        dismissViewController()
        searchObserver.accept(text)
        viewModel.action(input: .searchButtonTapped(text: text))
    }

}

extension SearchViewController: RecentHistoryTableViewCellDelegate {
    
    func removeKeywordButtonTapped(index: Int) {
        viewModel.action(input: .deleteSearchHistory(index: index))
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recentHistoryTableView {
            guard let keyword = recentHistoryDataSource.itemIdentifier(for: indexPath) else { return }
            search(text: keyword)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == recentHistoryTableView {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: RecentHistoryHeaderView.identifier
            ) else { return nil }
            return headerView
        } else { return nil }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == recentHistoryTableView {
            return 38
        } else { return 0 }
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            search(text: text)
            return true
        } else {
            return false
        }
    }
    
}
