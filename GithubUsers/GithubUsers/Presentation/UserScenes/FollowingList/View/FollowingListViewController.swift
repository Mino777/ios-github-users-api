//
//  FollowingListViewController.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import UIKit

import RxSwift

final class FollowingListViewController: UIViewController {
    private lazy var userListView = UserListView()
    weak var coordinator: FollowingListViewCoordinator?
    private let viewModel: FollowingListViewModelable
    private let disposeBag = DisposeBag()
    
    init(viewModel: FollowingListViewModelable) {
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            coordinator?.pop()
        }
    }
}
