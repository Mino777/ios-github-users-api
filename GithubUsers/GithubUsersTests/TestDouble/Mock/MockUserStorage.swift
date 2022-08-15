//
//  MockUserStorage.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/15.
//

import RxSwift

@testable import GithubUsers

final class MockUserStorage: UserStorageable {
    var callCount: Int = 0
    
    func create(_ item: UserRealm) {
        callCount += 1
    }
    
    var followingUsersSubject: BehaviorSubject<UserStorageState> {
        callCount += 1
        return BehaviorSubject<UserStorageState>(value: .success(items: []))
    }
    
    func followingObservable() -> Observable<[User]> {
        callCount += 1
        return Observable.just([])
    }
    
    func update(_ item: UserRealm) {
        callCount += 1
    }
    
    func delete(_ item: UserRealm) {
        callCount += 1
    }
}
