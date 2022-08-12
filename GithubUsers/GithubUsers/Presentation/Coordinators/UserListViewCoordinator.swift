//
//  UserListViewCoordinator.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import UIKit

final class UserListViewCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private unowned let dependencies: UserSceneDIContainerable
    private weak var viewController: UserListViewController?
    
    init(navigationController: UINavigationController, dependencies: UserSceneDIContainerable) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
}

extension UserListViewCoordinator {
    func start() {
        let userListViewController = dependencies.makeUserListViewController()
        userListViewController.coordinator = self
        self.navigationController?.pushViewController(userListViewController, animated: true)
    }
    
    func showMyFollowing() {
        
    }
}
