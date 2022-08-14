//
//  FollowingListViewController.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import UIKit

import RxSwift

final class FollowingListViewController: UIViewController, Alertable {
    private lazy var followingListView = FollowingListView()
    weak var coordinator: FollowingListViewCoordinator?
    private let viewModel: FollowingListViewModelable
    private let disposeBag = DisposeBag()
    
    private typealias DataSource = UITableViewDiffableDataSource<Int, User>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, User>
    private var dataSource: DataSource?
        
    init(viewModel: FollowingListViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        makeDataSource()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            coordinator?.pop()
        }
    }
}

// MARK: Setup, Datasource & Snapshot

extension FollowingListViewController {
    private func setupView() {
        setupViewAttribute()
        addSubviews()
        setupConstraint()
        setupNavigationBar()
    }
    
    private func setupViewAttribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(followingListView)
    }
    
    private func setupConstraint() {
        followingListView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigationBar() {
        title = "내 팔로잉"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func makeDataSource() {
        dataSource = DataSource(tableView: followingListView.followingListTableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: FollowingListTableViewCell.identifier,
                for: indexPath
            ) as? FollowingListTableViewCell
            
            let cellViewModel = FollowingListCellViewModel(user: itemIdentifier)
            
            cell?.bind(cellViewModel)
            cell?.didTapUnFollowButton
                .withUnretained(self)
                .subscribe { wself, _ in
                    wself.viewModel.didTapUnFollowButton(
                        user: itemIdentifier
                    )
                }
                .disposed(by: cell?.disposeBag ?? DisposeBag())
            
            return cell
        }
    }
    
    private func applySnapshot(items: [User]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.zero])
        snapshot.appendItems(items)
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
}

// MARK: bind

extension FollowingListViewController {
    private func bind() {
        viewModel.state
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { wself, state in
                switch state {
                case .showErrorAlertEvent(let error):
                    wself.showErrorAlertWithConfirmButton(error)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.users
            .withUnretained(self)
            .subscribe { wself, users in
                wself.applySnapshot(items: users)
            }
            .disposed(by: disposeBag)
    }
}
