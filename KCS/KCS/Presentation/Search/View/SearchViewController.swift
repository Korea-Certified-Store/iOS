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
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.plain()
        config.image = .backButton
        config.baseForegroundColor = .grayLabel
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
        
        view.searchTextField.rx.text
            .bind { [weak self] text in
                self?.viewModel.action(input: .textChanged(text: text ?? ""))
            }
            .disposed(by: disposeBag)
        
        view.xmarkImageView.rx
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
                    self?.searchObserver.accept(text)
                }
            })
            .disposed(by: disposeBag)
        
        return view
    }()
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.rowHeight = 49
        
        return tableView
    }()
    
    enum Section {
        case keyword
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
        view.addSubview(searchTableView)
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
            searchTableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 10),
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
    }
    
}

private extension SearchViewController {
    
    func generateData(data: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.keyword])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let text = dataSource.itemIdentifier(for: indexPath) else { return }
        dismissViewController()
        searchObserver.accept(text)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            searchObserver.accept(text)
            dismissViewController()
            return true
        } else {
            return false
        }
    }
    
}
