//
//  MockUserRepository.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/15.
//

import RxSwift

@testable import GithubUsers

final class MockUserRepository: UserRepositoriable {
    var followingUsers: [User]
    var allUsers: [User]
    var callCount: Int = 0

    init(followingUsers: [User], allUsers: [User]) {
        self.followingUsers = followingUsers
        self.allUsers = allUsers
    }
    
    func requestUserList(_ endpoint: Endpoint = EndpointStorage.users.endPoint) -> Observable<[User]> {
        callCount += 1
        return Observable.just(allUsers)
    }
    
    func create(_ item: User) {
        callCount += 1
    }
    
    var followingUsersSubject: BehaviorSubject<UserStorageState> {
        callCount += 1
        return BehaviorSubject<UserStorageState>(value: .success(items: []))
    }
    
    func followingObservable() -> Observable<[User]> {
        callCount += 1
        return Observable.just(followingUsers)
    }

    func delete(_ item: User) {
        callCount += 1
    }
}
