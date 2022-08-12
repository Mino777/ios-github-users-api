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
    private lazy var userListView = UserListView(viewModel: viewModel)
    weak var coordinator: UserListViewCoordinator?
    private let viewModel: UserListViewModelable
    private let disposeBag = DisposeBag()
    
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
        viewModel.requestUserList()
    }
}

extension UserListViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        addSubviews()
        setupConstraint()
        setupNavigationBar()
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
}

extension UserListViewController {
    private func bind() {
        viewModel.state
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
        
        navigationItem.rightBarButtonItem?.rx.tap
            .asDriver()
            .drive(with: self, onNext: { wself, _ in
                wself.viewModel.showMyFollowingView()
            })
            .disposed(by: disposeBag)
    }
}
