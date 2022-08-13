//
//  UserListViewController.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import UIKit

import SnapKit
import RxSwift

final class UserListViewController: UIViewController, Alertable {
    private lazy var userListView = UserListView()
    weak var coordinator: UserListViewCoordinator?
    private let viewModel: UserListViewModelable
    private let disposeBag = DisposeBag()
    
    private typealias DataSource = UITableViewDiffableDataSource<Int, User>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, User>
    private var dataSource: DataSource?
    
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: UserListViewModelable) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestUserList()
    }
}

extension UserListViewController {
    private func setupView() {
        setupViewAttribute()
        addSubviews()
        setupConstraint()
        setupNavigationBar()
    }
    
    private func setupViewAttribute() {
        view.backgroundColor = .systemBackground
        userListView.userListTableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "새로고침")
    }
    
    private func addSubviews() {
        view.addSubview(userListView)
    }
    
    private func setupConstraint() {
        userListView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigationBar() {
        title = "사용자 리스트"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "내 팔로잉", style: .plain, target: self, action: nil)
    }
    
    private func makeDataSource() {
        dataSource = DataSource(tableView: userListView.userListTableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: UserListTableViewCell.identifier,
                for: indexPath
            ) as? UserListTableViewCell
            
            let cellViewModel = UserListCellViewModel(user: itemIdentifier)
            
            cell?.bind(cellViewModel)
            cell?.didTapFollowButton
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .withUnretained(self)
                .subscribe { wself, _ in
                    wself.viewModel.didTapFollowButton(
                        user: itemIdentifier,
                        isFollowing: cellViewModel.user.isFollowing
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

extension UserListViewController {
    private func bind() {
        viewModel.state
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { wself, state in
                switch state {
                case .showErrorAlertEvent(let error):
                    wself.showErrorAlertWithConfirmButton(error)
                case .showMyFollowingView:
                    wself.coordinator?.showMyFollowing()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.users
            .withUnretained(self)
            .subscribe { wself, users in
                wself.applySnapshot(items: users)
            }
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self) { wself, _ in
                wself.viewModel.refreshLoading.accept(true)
                wself.viewModel.requestUserList()
            }
            .disposed(by: disposeBag)
        
        viewModel.refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(with: self) { wself, _ in
                wself.viewModel.showMyFollowingView()
            }
            .disposed(by: disposeBag)
        
        userListView.userListTableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { wself, indexPath in
                wself.userListView.userListTableView.deselectRow(at: indexPath, animated: true)
                wself.coordinator?.showUserDetail(user: wself.viewModel.users.value[safe: indexPath.row] ?? User.empty)
            }
            .disposed(by: disposeBag)
    }
}
