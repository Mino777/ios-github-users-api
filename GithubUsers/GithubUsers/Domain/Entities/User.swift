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

#if DEBUG
extension User {
    static func sampleData() -> [User] {
        var tempData = [User]()
        
        for index in 0 ..< 10 {
            tempData.append(User(login: "임시 사용자 이름\(index)", id: index, avatarURL: "", followersURL: "", followingURL: "", isFollowing: index % 2 == 0 ? true : false))
        }
        
        return tempData
    }
}
#endif
