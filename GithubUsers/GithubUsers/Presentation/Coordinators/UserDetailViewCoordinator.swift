//
//  UserDetailViewCoordinator.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import UIKit

final class UserDetailViewCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private unowned let factory: UserDetailViewFactoriable
    
    init(navigationController: UINavigationController, factory: UserDetailViewFactoriable) {
        self.navigationController = navigationController
        self.factory = factory
    }
}

extension UserDetailViewCoordinator {
    func start(_ user: User) {
        let UserDetailViewController = factory.makeUserDetailViewController(user)
        UserDetailViewController.coordinator = self
        navigationController?.pushViewController(UserDetailViewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
        parentCoordinator?.removeChild(self)
    }
}
