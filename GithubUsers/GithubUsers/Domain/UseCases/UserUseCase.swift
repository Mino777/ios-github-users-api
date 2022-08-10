//
//  UserUseCase.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

protocol UserUseCaseable {
    
}

final class UserUseCase {
    
    private let userRepository: UserRepositoriable
    
    init(userRepository: UserRepositoriable) {
        self.userRepository = userRepository
    }
}

extension UserUseCase: UserUseCaseable {
    
}
