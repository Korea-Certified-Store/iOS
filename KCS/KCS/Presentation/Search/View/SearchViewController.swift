//
//  SearchViewController.swift
//  KCS
//
//  Created by 조성민 on 2/8/24.
//

import UIKit
import RxSwift
import RxRelay
import RxKeyboard

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
        view.searchTextField.enablesReturnKeyAutomatically = true
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
                view.searchTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        view.searchImageView.rx
            .tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                view.searchTextField.becomeFirstResponder()
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
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false
        
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
                cell.delegate = self
                cell.selectionStyle = .none
                
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
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }()
    
    private lazy var autoCompletionDataSource: UITableViewDiffableDataSource<AutoCompletionSection, String> = {
        let dataSource = UITableViewDiffableDataSource<AutoCompletionSection, String>(
            tableView: autoCompletionTableView,
            cellProvider: { [weak self] (tableView, _, keyword) in
                guard let self = self,
                      let cell = tableView.dequeueReusableCell(
                    withIdentifier: AutoCompletionTableViewCell.identifier
                ) as? AutoCompletionTableViewCell else { return AutoCompletionTableViewCell() }
                cell.setUIContents(keyword: keyword)
                cell.setObserver(textObserver: textObserver)
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
    
    private let noHistoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "최근 검색 기록이 없습니다"
        label.font = UIFont.pretendard(size: 14, weight: .medium)
        label.textColor = .placeholderText
        
        return label
    }()
    
    private lazy var noHistoryView: UIView = {
        let imageView = UIImageView(image: SystemImage.toast)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .placeholderText
        
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.addSubview(imageView)
        view.addSubview(noHistoryLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 45),
            imageView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            noHistoryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            noHistoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return view
    }()
    
    private lazy var tableViewBottomConstraint = [
        autoCompletionTableView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        ),
        recentHistoryTableView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor
        )
    ]
    
    private let searchObserver: PublishRelay<String>
    private let textObserver: PublishRelay<String>
    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel, searchObserver: PublishRelay<String>, textObserver: PublishRelay<String>) {
        self.viewModel = viewModel
        self.searchObserver = searchObserver
        self.textObserver = textObserver
        
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
        recentHistoryTableView.addSubview(noHistoryView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 13),
            backButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            searchBarView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 13),
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
            noHistoryView.topAnchor.constraint(equalTo: divideView.bottomAnchor, constant: 179),
            noHistoryView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            recentHistoryTableView.topAnchor.constraint(equalTo: divideView.bottomAnchor),
            recentHistoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recentHistoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            autoCompletionTableView.topAnchor.constraint(equalTo: divideView.bottomAnchor),
            autoCompletionTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            autoCompletionTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate(tableViewBottomConstraint)
    }
    
    func bind() {
        viewModel.recentSearchKeywordsOutput
            .bind { [weak self] keywords in
                self?.noHistoryView.isHidden = true
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
        
        viewModel.changeTextColorOutput
            .bind { [weak self] text in
                self?.textObserver.accept(text)
            }
            .disposed(by: disposeBag)
        
        viewModel.searchOutput
            .bind { [weak self] keyword in
                self?.search(text: keyword)
            }
            .disposed(by: disposeBag)
        
        viewModel.noKeywordToastOutput
            .bind { [weak self] _ in
                self?.showToast(message: "검색어를 입력하세요.")
            }
            .disposed(by: disposeBag)
        
        viewModel.noRecentHistoryOutput
            .bind { [weak self] in
                guard let self = self else { return }
                noHistoryView.isHidden = false
            }
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .bind { [weak self] keyboardHeight in
                self?.tableViewBottomConstraint.forEach({ $0.constant = -keyboardHeight })
            }
            .disposed(by: disposeBag)
    }
    
}

private extension SearchViewController {
    
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
    
    func showToast(message: String) {
        let toastView = makeToastView(message: message)
        
        view.addSubview(toastView)
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            toastView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -view.frame.maxY + recentHistoryTableView.frame.maxY - 24
            )
        ])
        toastView.removeFromSuperviewWithAnimation()
    }

}

extension SearchViewController: RecentHistoryTableViewCellDelegate, RecentHistoryHeaderViewDelegate {
    
    func removeKeywordButtonTapped(index: Int) {
        viewModel.action(input: .deleteSearchHistory(index: index))
    }
    
    func clearAllButtonButtonTapped() {
        if !recentHistoryDataSource.snapshot().itemIdentifiers.isEmpty {
            let clearAllAlert = UIAlertController(
                title: "삭제하기",
                message: "최근 검색어를 모두 삭제하시겠습니까?",
                preferredStyle: .alert
            )
            let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
                self?.viewModel.action(input: .deleteAllHistory)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            clearAllAlert.addAction(delete)
            clearAllAlert.addAction(cancel)
            present(clearAllAlert, animated: true)
        }
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recentHistoryTableView {
            guard let keyword = recentHistoryDataSource.itemIdentifier(for: indexPath) else { return }
            search(text: keyword)
        }
        if tableView == autoCompletionTableView {
            guard let keyword = autoCompletionDataSource.itemIdentifier(for: indexPath) else { return }
            search(text: keyword)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == recentHistoryTableView {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: RecentHistoryHeaderView.identifier
            ) as? RecentHistoryHeaderView else { return nil }
            headerView.delegate = self
            
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
            viewModel.action(input: .returnKeyTapped(text: text))
        }
        return false
    }
    
}
