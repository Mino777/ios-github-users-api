//
//  NetworkServiceTests.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/14.
//

import XCTest
import RxSwift
@testable import GithubUsers

final class NetworkServiceTests: XCTestCase {
    var sut: NetworkServiceable!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let urlSession: URLSession = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [StubURLProtocol.self]
                return configuration
            }()
            return URLSession(configuration: configuration)
        }()
        sut = NetworkService(urlSession: urlSession)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        disposeBag = nil
    }
    
    func test_http통신을_요청했을때_StatusCode가200인경우_성공해야한다() {
        // given
        StubURLProtocol.setupResponseDTOType(with: .users)
        StubURLProtocol.setupResponseStatusCode(with: true)
        let endpoint = EndpointStorage.users.endPoint
        let expected = StubURLProtocol.dummyData()!
        let expectation = XCTestExpectation(description: "Networking Success")
        
        // when
        sut.request(endpoint: endpoint)
            .subscribe(onNext: { result in
                // then
                XCTAssertEqual(result, expected)
                expectation.fulfill()
            }, onError: { error in
                XCTFail()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_http통신을_요청했을때_StatusCode가404인경우_실패해야한다() {
        // given
        StubURLProtocol.setupResponseDTOType(with: .users)
        StubURLProtocol.setupResponseStatusCode(with: false)
        let endpoint = EndpointStorage.users.endPoint
        let expected = NetworkServiceError.notFound
        let expectation = XCTestExpectation(description: "Networking Failure")
        
        // when
        sut.request(endpoint: endpoint)
            .subscribe(onNext: { result in
                XCTFail()
            }, onError: { error in
                // then
                XCTAssertEqual(error as? NetworkServiceError, expected)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
}
