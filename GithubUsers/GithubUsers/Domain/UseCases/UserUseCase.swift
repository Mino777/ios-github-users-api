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
        return Observable.zip(
            userRepository.requestUserList(EndpointStorage.users.endPoint),
            userRepository.followingObservable()
        )
        .map { users, followingUsers in
            let followingUsersId = followingUsers.map { $0.id }
            return users.map {
                return User(
                    login: $0.login,
                    id: $0.id,
                    avatarURL: $0.avatarURL,
                    followersURL: $0.followersURL,
                    followingURL: $0.followingURL,
                    isFollowing: followingUsersId.contains($0.id)
                )
            }
        }
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
