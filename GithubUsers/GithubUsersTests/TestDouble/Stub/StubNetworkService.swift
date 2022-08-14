//
//  StubNetworkService.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/15.
//

import Foundation
import XCTest

import RxSwift
@testable import GithubUsers

final class StubNetworkService: NetworkServiceable {
    var data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func request(endpoint: Endpoint = EndpointStorage.users.endPoint) -> Observable<Data> {
        return Observable.just(data)
    }
}
