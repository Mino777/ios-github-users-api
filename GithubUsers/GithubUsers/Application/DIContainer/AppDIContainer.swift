//
//  AppDIContainer.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

protocol AppDIContainerable {
    func makeUserSceneDIContainer() -> UserSceneDIContainer
}

final class AppDIContainer: AppDIContainerable {
    
    private let userStorage = UserStorage()
    
    func makeUserSceneDIContainer() -> UserSceneDIContainer {
        return UserSceneDIContainer(
            dependencies: .init(userStorage: userStorage)
        )
    }
}
