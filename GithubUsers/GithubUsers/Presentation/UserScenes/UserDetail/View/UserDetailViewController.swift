//
//  UserDetailViewController.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import UIKit

import RxSwift

final class UserDetailViewController: UIViewController, Alertable {
    private lazy var userDetailView = UserDetailView()
    weak var coordinator: UserDetailViewCoordinator?
    private let viewModel: UserDetailViewModelable
    private let disposeBag = DisposeBag()
    
    private typealias DataSource = UITableViewDiffableDataSource<Int, User>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, User>
    private var dataSource: DataSource?
    
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: UserDetailViewModelable) {
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
        
        viewModel.viewDidBind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            coordinator?.pop()
        }
    }
}

extension UserDetailViewController {
    private func setupView() {
        setupViewAttribute()
        addSubviews()
        setupConstraint()
    }
    
    private func setupViewAttribute() {
        view.backgroundColor = .systemBackground
        userDetailView.followListTableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "새로고침")
    }
    
    private func addSubviews() {
        view.addSubview(userDetailView)
    }
    
    private func setupConstraint() {
        userDetailView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func makeDataSource() {
        dataSource = DataSource(tableView: userDetailView.followListTableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: UserDetailTableViewCell.identifier,
                for: indexPath
            ) as? UserDetailTableViewCell
            
            let cellViewModel = UserDetailCellViewModel(user: itemIdentifier)
            
            cell?.bind(cellViewModel)
            
            return cell
        }
    }
    
    private func applySnapshot(items: [User]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.zero])
        snapshot.appendItems(items)
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension UserDetailViewController {
    private func bind() {
        viewModel.state
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { wself, state in
                switch state {
                case .showErrorAlertEvent(let error):
                    wself.showErrorAlertWithConfirmButton(error)
                    wself.applySnapshot(items: [])
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.users
            .withUnretained(self)
            .subscribe { wself, users in
                wself.applySnapshot(items: users)
            }
            .disposed(by: disposeBag)
        
        viewModel.userImageEvent
            .withUnretained(self)
            .subscribe { wself, url in
                wself.userDetailView.avatarImageView.tmon.setImage(url)
            }
            .disposed(by: disposeBag)
        
        viewModel.userNameEvent
            .bind(to: userDetailView.userNameLabel.rx.text)
            .disposed(by: disposeBag)
                
        refreshControl.rx.controlEvent(.valueChanged)
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self) { wself, _ in
                wself.viewModel.refreshLoading.accept(true)
                
                if wself.viewModel.isFollwoing.value {
                    wself.viewModel.requestFollowingList()
                } else {
                    wself.viewModel.requestFollowerList()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.refreshLoading
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        userDetailView.followingButton.rx.tap
            .withUnretained(self)
            .subscribe { wself, _ in
                wself.viewModel.requestFollowingList()
                wself.userDetailView.changeFollowButton(true)
            }
            .disposed(by: disposeBag)
        
        userDetailView.followerButton.rx.tap
            .withUnretained(self)
            .subscribe { wself, _ in
                wself.viewModel.requestFollowerList()
                wself.userDetailView.changeFollowButton(false)
            }
            .disposed(by: disposeBag)
        
        viewModel.userFollowingState
            .withUnretained(self)
            .subscribe { wself, state in
                wself.userDetailView.changeFollowStateButton(state)
                let followStateButton = UIBarButtonItem(customView: wself.userDetailView.followStateButton)
                wself.navigationItem.setRightBarButton(followStateButton, animated: true)
            }
            .disposed(by: disposeBag)
        
        userDetailView.followStateButton.rx.tap
            .withUnretained(self)
            .subscribe { wself, _ in
                wself.viewModel.didTapFollowButton()
            }
            .disposed(by: disposeBag)
    }    
}
