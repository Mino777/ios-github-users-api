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
        return Observable.just(users)
    }
    
    func requestFollowingList(_ url: String) -> Observable<[User]> {
        return Observable.just(users)
    }
    
    func create(_ item: User) {
        users.append(item)
    }
    
    var followingUsersSubject: BehaviorSubject<UserStorageState> {
        return BehaviorSubject<UserStorageState>(value: .success(items: users))
    }
    
    func delete(_ item: User) {
        users.removeAll(where: { $0.id == item.id })
    }    
}
