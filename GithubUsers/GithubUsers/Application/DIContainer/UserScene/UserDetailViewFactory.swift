//
//  UserDetailViewFactory.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import UIKit

protocol UserDetailViewFactoriable: AnyObject {
    func makeUserDetailViewController(_ user: User) -> UserDetailViewController
    func makeUserDetailViewCoordinator(navigationController: UINavigationController) -> UserDetailViewCoordinator
}

final class UserDetailViewFactory {
    struct Dependencies {
        let userUseCase: UserUseCaseable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: Make Layer Component

extension UserDetailViewFactory: UserDetailViewFactoriable {
    
    // MARK: ViewController
    
    func makeUserDetailViewController(_ user: User) -> UserDetailViewController {
        return UserDetailViewController(viewModel: makeUserDetailViewModel(user))
    }

    // MARK: ViewModel
    
    private func makeUserDetailViewModel(_ user: User) -> UserDetailViewModelable {
        return UserDetailViewModel(useCase: dependencies.userUseCase, user: user)
    }

    // MARK: Coordinator
    
    func makeUserDetailViewCoordinator(navigationController: UINavigationController) -> UserDetailViewCoordinator {
        return UserDetailViewCoordinator(navigationController: navigationController, factory: self)
    }
}
