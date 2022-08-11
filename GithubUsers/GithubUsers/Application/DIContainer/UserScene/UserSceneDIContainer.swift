//
//  UserSceneDIContainer.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import UIKit

protocol UserSceneDIContainerable: AnyObject {
    func makeUserListViewController() -> UserListViewController
    func makeUserListViewCoordinator(navigationController: UINavigationController) -> UserListViewCoordinator
}

final class UserSceneDIContainer {
    
    struct Dependencies {
        unowned let userStorage: UserStorageable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension UserSceneDIContainer: UserSceneDIContainerable {
    
    func makeUserListViewController() -> UserListViewController {
        return UserListViewController(viewModel: makeUserListViewModel())
    }
    
    func makeUserListViewCoordinator(
        navigationController: UINavigationController
    ) -> UserListViewCoordinator {
        return UserListViewCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    private func makeUserListViewModel() -> UserListViewModelable {
        return UserListViewModel(useCase: makeUserUseCase())
    }
    
    private func makeUserUseCase() -> UserUseCaseable {
        return UserUseCase(userRepository: makeUserRepository())
    }
    
    private func makeUserRepository() -> UserRepositoriable {
        return UserRepository(userStorage: dependencies.userStorage)
    }
}
