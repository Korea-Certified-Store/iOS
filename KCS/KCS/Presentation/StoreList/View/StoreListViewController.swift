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
    
    private let listCellSelectedObserver: PublishRelay<Int>
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "가게 모아보기"
        label.font = UIFont.pretendard(size: 16, weight: .medium)
        label.textColor = .black
        
        return label
    }()
    
    private let storeCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.pretendard(size: 14, weight: .regular)
        label.textColor = .kcsGray1
        
        return label
    }()
    
    private let divideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.kcsGray2
        
        return view
    }()
    
    private let storeTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 109
        tableView.register(StoreTableViewCell.self, forCellReuseIdentifier: StoreTableViewCell.identifier)
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    private let emptyListImageView: UIImageView = {
        let imageView = UIImageView(image: SystemImage.exclamationmark)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .placeholderText
        
        return imageView
    }()
    
    private let emptyListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "주변 가게 정보를 찾을 수 없습니다"
        label.font = UIFont.pretendard(size: 14, weight: .medium)
        label.textColor = .placeholderText
        
        return label
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
            cell.selectionStyle = .none
            
            return cell
        }
    }()
    
    private let viewModel: StoreListViewModel
    
    init(viewModel: StoreListViewModel, listCellSelectedObserver: PublishRelay<Int>) {
        self.viewModel = viewModel
        self.listCellSelectedObserver = listCellSelectedObserver
        
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
        storeTableView.isHidden = false
    }
    
    func updateCountLabel(text: String) {
        storeCountLabel.text = text
    }
    
    func emptyStoreList() {
        storeTableView.isHidden = true
    }
    
    func scrollToPreviousCell(indexPath: IndexPath) {
        storeTableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
}

private extension StoreListViewController {
    
    func setup() {
        isModalInPresentation = true
        storeTableView.delegate = self
        view.backgroundColor = .white
    }
    
    func addUIComponents() {
        view.addSubview(emptyListImageView)
        view.addSubview(emptyListLabel)
        view.addSubview(storeTableView)
        view.addSubview(titleLabel)
        view.addSubview(storeCountLabel)
        view.addSubview(divideView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            storeCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            storeCountLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divideView.topAnchor.constraint(equalTo: storeCountLabel.bottomAnchor, constant: 23),
            divideView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            divideView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            divideView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            emptyListImageView.topAnchor.constraint(equalTo: divideView.bottomAnchor, constant: 234),
            emptyListImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyListImageView.widthAnchor.constraint(equalToConstant: 45),
            emptyListImageView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            emptyListLabel.topAnchor.constraint(equalTo: emptyListImageView.bottomAnchor, constant: 16),
            emptyListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            storeTableView.topAnchor.constraint(equalTo: divideView.bottomAnchor),
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
        listCellSelectedObserver.accept(indexPath.row)
    }
    
}
