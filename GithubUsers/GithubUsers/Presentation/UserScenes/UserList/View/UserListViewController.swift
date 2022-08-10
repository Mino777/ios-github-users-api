//
//  UserListViewController.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import UIKit

import SnapKit

final class UserListViewController: UIViewController {

    private lazy var userListView = UserListView()
    weak var coordinator: UserListViewCoordinator?
    private let viewModel: UserListViewModelable
    
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
    }
}

extension UserListViewController {
    
    private func setupView() {
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        view.addSubview(userListView)
    }
    
    private func setupConstraint() {
        userListView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
