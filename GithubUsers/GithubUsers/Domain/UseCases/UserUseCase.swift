//
//  UserUseCase.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import RxSwift

protocol UserUseCaseable {
    func requestUserList() -> Observable<[User]>
}

final class UserUseCase {
    private let userRepository: UserRepositoriable
    
    init(userRepository: UserRepositoriable) {
        self.userRepository = userRepository
    }
}

extension UserUseCase: UserUseCaseable {
    func requestUserList() -> Observable<[User]> {
        userRepository.requestUserList(EndpointStorage.users.endPoint)
    }
}
