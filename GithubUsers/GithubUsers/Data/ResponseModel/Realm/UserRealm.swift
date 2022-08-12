//
//  UserRealmDTO.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/11.
//

import Foundation

import RealmSwift

final class UserRealm: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var login: String
    @Persisted var avatarURL: String
    @Persisted var followersURL: String
    @Persisted var followingURL: String
    @Persisted var isFollowing: Bool
    
    convenience init(
        id: Int,
        login: String,
        avatarURL: String,
        followersURL: String,
        followingURL: String,
        isFollowing: Bool
    ) {
        self.init()
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.followersURL = followersURL
        self.followingURL = followingURL
        self.isFollowing = isFollowing
    }
}

extension UserRealm {
    func toDomain() -> User {
        return User(
            login: login,
            id: id,
            avatarURL: avatarURL,
            followersURL: followersURL,
            followingURL: followingURL,
            isFollowing: isFollowing
        )
    }
}
