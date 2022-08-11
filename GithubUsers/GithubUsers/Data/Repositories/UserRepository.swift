//
//  UserRepository.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import RxSwift
import Foundation

final class UserRepository {
    private let userStorage: UserStorageable
    private let networkService: NetworkServiceable
    
    init(userStorage: UserStorageable, networkService: NetworkServiceable) {
        self.userStorage = userStorage
        self.networkService = networkService
    }
}

extension UserRepository: UserRepositoriable {
    func requestUserList(_ endpoint: Endpoint) -> Observable<[User]> {
        return networkService.request(endpoint: endpoint)
            .map { data -> [User] in
                let jsonDecoder = JSONDecoder()
                let decodedData = try? jsonDecoder.decode([UserResponseDTO].self, from: data)
                let users = decodedData?.map {
                    $0.toDomain()
                }
                return users ?? []
            }
    }
}
