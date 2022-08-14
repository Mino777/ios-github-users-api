//
//  User.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import Foundation

struct User: Hashable {
    let login: String
    let id: Int
    let avatarURL: String
    let followersURL: String
    let followingURL: String
    var isFollowing: Bool
    
    static let empty: Self = User(
        login: "",
        id: -1,
        avatarURL: "",
        followersURL: "",
        followingURL: "",
        isFollowing: false
    )
}
