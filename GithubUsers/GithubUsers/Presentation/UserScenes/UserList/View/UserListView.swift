//
//  UserListView.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import UIKit

import RxSwift

final class UserListView: UIView {
    private typealias DataSource = UITableViewDiffableDataSource<Int, User>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, User>
    private var dataSource: DataSource?
    
    private let viewModel: UserListViewModelable
    private let disposeBag = DisposeBag()
    
    let userListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: UserListTableViewCell.identifier)
        return tableView
    }()
    
    init(viewModel: UserListViewModelable) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupView()
        makeDataSource()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        addSubview(userListTableView)
    }
    
    private func setupConstraint() {
        userListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func makeDataSource() {
        dataSource = DataSource(tableView: userListTableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: UserListTableViewCell.identifier,
                for: indexPath
            ) as? UserListTableViewCell
            
            let cellViewModel = UserListCellViewModel(user: itemIdentifier)
            
            cell?.bind(cellViewModel)
            cell?.didTapFollowButton
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
    
    private func bind() {
        viewModel.users
            .withUnretained(self)
            .subscribe { wself, users in
                wself.applySnapshot(items: users)
            }
            .disposed(by: disposeBag)
    }
    
    private func applySnapshot(items: [User]) {
        var snapshot = Snapshot()
        DispatchQueue.main.async {
            snapshot.appendSections([.zero])
            snapshot.appendItems(items)
            self.dataSource?.apply(snapshot)
        }
    }
}
