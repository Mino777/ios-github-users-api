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

extension FollowingListViewFactory: FollowingListViewFactoriable {
    func makeFollowingListViewController() -> FollowingListViewController {
        return FollowingListViewController(viewModel: makeFollowingListViewModel())
    }

    private func makeFollowingListViewModel() -> FollowingListViewModelable {
        return FollowingListViewModel(useCase: dependencies.userUseCase)
    }

    func makeFollowingListViewCoordinator(navigationController: UINavigationController) -> FollowingListViewCoordinator {
        return FollowingListViewCoordinator(navigationController: navigationController, factory: self)
    }
}
