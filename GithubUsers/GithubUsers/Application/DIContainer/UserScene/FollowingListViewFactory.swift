//
//  FollowingListViewFactory.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import UIKit

protocol FollowingListViewFactoriable: AnyObject {
    func makeFollowingListViewController() -> FollowingListViewController
    func makeFollowingListViewCoordinator(navigationController: UINavigationController) -> FollowingListViewCoordinator
}

final class FollowingListViewFactory {
    struct Dependencies {
        let userUseCase: UserUseCaseable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: Make Layer Component

extension FollowingListViewFactory: FollowingListViewFactoriable {
    
    // MARK: ViewController
    
    func makeFollowingListViewController() -> FollowingListViewController {
        return FollowingListViewController(viewModel: makeFollowingListViewModel())
    }

    // MARK: ViewModel
    
    private func makeFollowingListViewModel() -> FollowingListViewModelable {
        return FollowingListViewModel(useCase: dependencies.userUseCase)
    }

    // MARK: Coordinator
    
    func makeFollowingListViewCoordinator(navigationController: UINavigationController) -> FollowingListViewCoordinator {
        return FollowingListViewCoordinator(navigationController: navigationController, factory: self)
    }
}
