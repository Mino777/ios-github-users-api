//
//  AppCoordinator.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
}

final class AppCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let appDIContainer: AppDIContainerable
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainerable) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        guard let navigationController = navigationController else { return }

        let sceneDIContainer = appDIContainer.makeUserSceneDIContainer()
        let sceneCoordinator = sceneDIContainer.makeUserListViewCoordinator(
            navigationController: navigationController
        )

        childCoordinators.append(sceneCoordinator)
        sceneCoordinator.parentCoordinator = self

        sceneCoordinator.start()
    }
}
