//
//  UserUseCase.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import RxSwift

protocol UserUseCaseable {
    func requestUserList() -> Observable<[User]>
    func create(_ item: User)
    var followingUsersSubject: BehaviorSubject<UserStorageState> { get }
    func delete(_ item: User)
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
    
    func create(_ item: User) {
        userRepository.create(item)
    }
    
    var followingUsersSubject: BehaviorSubject<UserStorageState> {
        userRepository.followingUsersSubject
    }
    
    func delete(_ item: User) {
        userRepository.delete(item)
    }
}
