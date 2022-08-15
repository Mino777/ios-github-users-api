//
//  StubUserUseCase.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/15.
//

import RxSwift

@testable import GithubUsers

final class StubUserUseCase: UserUseCaseable {
    var users: [User] = []
    var user: User = User(
        login: "",
        id: 4,
        avatarURL: "",
        followersURL: "",
        followingURL: "",
        isFollowing: false
    )
    var isSuccess: Bool = true

    init(users: [User]) {
        self.users = users
    }
    
    func requestUserList() -> Observable<[User]> {
        if isSuccess {
            return Observable.just(users)
        } else {
            return Observable.error(NetworkServiceError.badRequest)
        }
    }
    
    func requestFollowerList(_ url: String) -> Observable<[User]> {
        if isSuccess {
            return Observable.just(users)
        } else {
            return Observable.error(NetworkServiceError.badRequest)
        }
    }
    
    func requestFollowingList(_ url: String) -> Observable<[User]> {
        if isSuccess {
            return Observable.just(users)
        } else {
            return Observable.error(NetworkServiceError.badRequest)
        }
    }
    
    func create(_ item: User) {
        users.append(item)
    }
    
    var followingUsersSubject: BehaviorSubject<UserStorageState> {
        if isSuccess {
            return BehaviorSubject<UserStorageState>(value: .success(items: users))
        } else {
            return BehaviorSubject<UserStorageState>(value: .failure(error: .readFail))
        }
    }
    
    func delete(_ item: User) {
        users.removeAll(where: { $0.id == item.id })
    }    
}
