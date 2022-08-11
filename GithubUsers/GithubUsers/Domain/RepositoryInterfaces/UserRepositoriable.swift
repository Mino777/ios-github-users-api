//
//  UserRepositoriable.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import RxSwift

protocol UserRepositoriable {
    func requestUserList(_ endpoint: Endpoint) -> Observable<[User]>
    func create(_ item: User)
    var followingUsersSubject: BehaviorSubject<UserStorageState> { get }
    func followingObservable() -> Observable<[User]>
    func delete(_ item: User)
}
