//
//  UserDetailViewController.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import UIKit

import RxSwift

final class UserDetailViewController: UIViewController, Alertable {
    private lazy var followingListView = FollowingListView()
    weak var coordinator: UserDetailViewCoordinator?
    private let viewModel: UserDetailViewModelable
    private let disposeBag = DisposeBag()
    
    private typealias DataSource = UITableViewDiffableDataSource<Int, User>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, User>
    private var dataSource: DataSource?
    
    init(viewModel: UserDetailViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
