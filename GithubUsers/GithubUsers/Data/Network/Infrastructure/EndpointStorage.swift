//
//  EndpointStorage.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/11.
//

import Foundation

enum EndpointStorage {
    private enum Constants {
        static let baseURL = "https://api.github.com/users"
    }
    
    case users
    case followers(_ url: String)
    case following(_ url: String)
    
    var endPoint: Endpoint {
        switch self {
        case .users:
            return Endpoint(baseURL: Constants.baseURL, method: .get)
        case .followers(let url):
            return Endpoint(baseURL: url, method: .get)
        case .following(let url):
            return Endpoint(baseURL: url, method: .get)
        }
    }
}
