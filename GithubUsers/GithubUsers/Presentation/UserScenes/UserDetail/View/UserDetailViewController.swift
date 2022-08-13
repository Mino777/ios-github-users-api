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
//        bind()
//        makeDataSource()
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
        setupNavigationBar()
    }
    
    private func setupViewAttribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(userDetailView)
    }
    
    private func setupConstraint() {
        userDetailView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userDetailView.followStateButton)
    }
}
