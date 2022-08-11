//
//  UserRepository.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

final class UserRepository {
    private let userStorage: UserStorageable
    private let networkService: NetworkServiceable
    
    init(userStorage: UserStorageable, networkService: NetworkServiceable) {
        self.userStorage = userStorage
        self.networkService = networkService
    }
}

extension UserRepository: UserRepositoriable {
    
}
