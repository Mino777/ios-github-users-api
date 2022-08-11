//
//  UserRepositoriable.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import RxSwift

protocol UserRepositoriable {
    func requestUserList(_ endpoint: Endpoint) -> Observable<[User]>
}
