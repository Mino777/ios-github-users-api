//
//  UserResponseDTO.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import Foundation

struct UserResponseDTO: Decodable {
    let login: String
    let id: Int
    let avatarURL: String
    let followersURL: String
    let followingURL: String
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
    }
}

extension UserResponseDTO {
    func toDomain() -> User {
        return User(
            login: login,
            id: id,
            avatarURL: avatarURL,
            followersURL: followersURL,
            followingURL: replaceURLBrace(followingURL),
            isFollowing: false
        )
    }
    
    private func replaceURLBrace(_ url: String) -> String {
        return url.replacingOccurrences(of: "{/other_user}", with: "")
    }
}
