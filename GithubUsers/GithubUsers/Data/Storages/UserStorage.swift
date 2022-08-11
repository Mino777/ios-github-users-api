//
//  UserStorage.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import Foundation

import RxSwift
import RealmSwift

enum StorageError: LocalizedError {
    case createFail
    case updateFail
    case deleteFail
    case readFail
    
    var errorDescription: String? {
        switch self {
        case .createFail:
            return "데이터를 생성하지 못했습니다."
        case .updateFail:
            return "데이터를 업데이트하지 못했습니다."
        case .deleteFail:
            return "데이터를 삭제하지 못했습니다."
        case .readFail:
            return "데이터를 불러오지 못했습니다."
        }
    }
}

protocol UserStorageable: AnyObject {
    func create(_ item: User)
    var followingUsersSubject: BehaviorSubject<UserStorageState> { get }
    func update(_ item: User)
    func delete(_ item: User)
}

enum UserStorageState {
    case success(items: [User])
    case failure(error: StorageError)
}

final class UserStorage: UserStorageable {
    private let realm = try! Realm()
    private let followingUsers = BehaviorSubject<UserStorageState>(value: .success(items: []))
    
    init() {
        followingUsers.onNext(.success(items: readFollowingUsers()))
    }
    
    func create(_ item: User) {
        write(.createFail) { [weak self] in
            guard let self = self else { return }
            self.realm.add(self.transferToTodoRealm(with: item))
            self.followingUsers.onNext(.success(items: self.readFollowingUsers()))
        }
    }

    var followingUsersSubject: BehaviorSubject<UserStorageState> {
        return followingUsers
    }
    
    func update(_ item: User) {
        write(.updateFail) { [weak self] in
            guard let self = self else { return }
            self.realm.add(self.transferToTodoRealm(with: item), update: .modified)
            self.followingUsers.onNext(.success(items: self.readFollowingUsers()))
        }
    }
    
    func delete(_ item: User) {
        write(.deleteFail) {
            guard let realmModel = self.realm.object(ofType: UserRealm.self, forPrimaryKey: item.id) else {
                return
            }
            self.realm.delete(realmModel)
            self.followingUsers.onNext(.success(items: self.readFollowingUsers()))
        }
    }
    
    private func write(_ realmError: StorageError, _ completion: @escaping () -> Void) {
        do {
            try self.realm.write { completion() }
        } catch {
            followingUsers.onNext(.failure(error: realmError))
        }
    }
    
    private func readFollowingUsers() -> [User] {
        return realm
            .objects(UserRealm.self)
            .where { $0.isFollowing == true }
            .map(transferToTodo)
    }
    
    private func transferToTodoRealm(with item: User) -> UserRealm {
        return UserRealm(
            id: item.id,
            login: item.login,
            avatarURL: item.avatarURL,
            followersURL: item.followersURL,
            followingURL: item.followingURL,
            isFollowing: item.isFollowing
        )
    }
    
    private func transferToTodo(with item: UserRealm) -> User {
        return User(
            login: item.login,
            id: item.id,
            avatarURL: item.avatarURL,
            followersURL: item.followersURL,
            followingURL: item.followingURL,
            isFollowing: item.isFollowing
        )
    }
}
