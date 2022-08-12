//
//  FollowingListViewCoordinator.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import UIKit

final class FollowingListViewCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private unowned let factory: FollowingListViewFactoriable
    private weak var viewController: UserListViewController?
    
    init(navigationController: UINavigationController, factory: FollowingListViewFactoriable) {
        self.navigationController = navigationController
        self.factory = factory
    }
}

extension FollowingListViewCoordinator {
    func start() {
        let followingListViewController = factory.makeFollowingListViewController()
        followingListViewController.coordinator = self
        navigationController?.pushViewController(followingListViewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
        parentCoordinator?.removeChild(self)
    }
}
