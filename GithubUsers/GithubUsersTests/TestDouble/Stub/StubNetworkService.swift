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
    var callCount: Int = 0
    
    init(data: Data) {
        self.data = data
    }
    
    func request(endpoint: Endpoint = EndpointStorage.users.endPoint) -> Observable<Data> {
        self.callCount += 1
        
        return Observable.just(data)
    }
    
    func verifyRequest(callCount: Int = 1) {
        XCTAssertEqual(self.callCount, callCount)
    }
}
