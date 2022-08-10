//
//  UserRepository.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

final class UserRepository {
    
    private let userStorage: UserStorageable
    
    init(userStorage: UserStorageable) {
        self.userStorage = userStorage
    }
}

extension UserRepository: UserRepositoriable {
    
}
