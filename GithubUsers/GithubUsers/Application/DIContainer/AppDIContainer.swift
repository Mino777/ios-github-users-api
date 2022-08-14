//
//  AppDIContainer.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

protocol AppDIContainerable {
    func makeUserSceneDIContainer() -> UserSceneDIContainer
}

final class AppDIContainer {
    private let userStorage = UserStorage()
    private let networkService = NetworkService()
}

// MARK: Make SceneDIContainer

extension AppDIContainer: AppDIContainerable {
    func makeUserSceneDIContainer() -> UserSceneDIContainer {
        return UserSceneDIContainer(
            dependencies: .init(
                userStorage: userStorage,
                networkService: networkService
            )
        )
    }
}
