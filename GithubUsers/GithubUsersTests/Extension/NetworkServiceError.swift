//
//  NetworkServiceError.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/15.
//

import XCTest
@testable import GithubUsers

extension NetworkServiceError: Equatable {
    public static func == (
        lhs: NetworkServiceError,
        rhs: NetworkServiceError
    ) -> Bool {
        return lhs.errorDescription == rhs.errorDescription
    }
}
