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

enum UserStorageState {
    case success(items: [User])
    case failure(error: StorageError)
}

protocol UserStorageable: AnyObject {
    func create(_ item: UserRealm)
    var followingUsersSubject: BehaviorSubject<UserStorageState> { get }
    func followingObservable() -> Observable<[User]>
    func update(_ item: UserRealm)
    func delete(_ item: UserRealm)
}

final class UserStorage: UserStorageable {
    private let realm = try! Realm()
    private let followingUsers = BehaviorSubject<UserStorageState>(value: .success(items: []))
    
    init() {
        followingUsers.onNext(.success(items: readAll()))
    }
    
    func create(_ item: UserRealm) {
        write(.createFail) { [weak self] in
            guard let self = self else { return }
            self.realm.add(item)
            self.followingUsers.onNext(.success(items: self.readAll()))
        }
    }

    var followingUsersSubject: BehaviorSubject<UserStorageState> {
        return followingUsers
    }
    
    func followingObservable() -> Observable<[User]> {
        return Observable.create { [weak self] emitter in
            guard let users = self?.readAll() else {
                emitter.onError(StorageError.readFail)
                return Disposables.create()
            }
            
            emitter.onNext(users)
            emitter.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func update(_ item: UserRealm) {
        write(.updateFail) { [weak self] in
            guard let self = self else { return }
            self.realm.add(item, update: .modified)
            self.followingUsers.onNext(.success(items: self.readAll()))
        }
    }
    
    func delete(_ item: UserRealm) {
        write(.deleteFail) { [weak self] in
            guard let self = self else { return }
            
            guard let realmModel = self.realm.object(ofType: UserRealm.self, forPrimaryKey: item.id) else {
                return
            }
            self.realm.delete(realmModel)
            self.followingUsers.onNext(.success(items: self.readAll()))
        }
    }
    
    private func write(_ realmError: StorageError, _ completion: @escaping () -> Void) {
        do {
            try self.realm.write { completion() }
        } catch {
            followingUsers.onNext(.failure(error: realmError))
        }
    }
    
    private func readAll() -> [User] {
        return realm
            .objects(UserRealm.self)
            .map(transferToTodo)
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
