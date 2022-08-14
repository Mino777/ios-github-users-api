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
    func makeFollowingListViewFactory() -> FollowingListViewFactoriable
    func makeUserDetailViewFactory() -> UserDetailViewFactoriable
}

final class UserSceneDIContainer {
    struct Dependencies {
        unowned let userStorage: UserStorageable
        unowned let networkService: NetworkServiceable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: Make Layer Component

extension UserSceneDIContainer: UserSceneDIContainerable {
    
    // MARK: ViewController
    
    func makeUserListViewController() -> UserListViewController {
        return UserListViewController(viewModel: makeUserListViewModel())
    }
    
    // MARK: Coordinator
    
    func makeUserListViewCoordinator(
        navigationController: UINavigationController
    ) -> UserListViewCoordinator {
        return UserListViewCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    // MARK: ViewModel
    
    private func makeUserListViewModel() -> UserListViewModelable {
        return UserListViewModel(useCase: makeUserUseCase())
    }
    
    // MARK: UseCase
    
    private func makeUserUseCase() -> UserUseCaseable {
        return UserUseCase(userRepository: makeUserRepository())
    }
    
    // MARK: Repository
    
    private func makeUserRepository() -> UserRepositoriable {
        return UserRepository(
            userStorage: dependencies.userStorage,
            networkService: dependencies.networkService
        )
    }
    
    // MARK: ViewFactory
    
    func makeFollowingListViewFactory() -> FollowingListViewFactoriable {
        return FollowingListViewFactory(
            dependencies: .init(userUseCase: makeUserUseCase())
        )
    }
    
    func makeUserDetailViewFactory() -> UserDetailViewFactoriable {
        return UserDetailViewFactory(
            dependencies: .init(userUseCase: makeUserUseCase())
        )
    }
}
