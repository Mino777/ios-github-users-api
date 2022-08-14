//
//  UserRepositoryTests.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/15.
//

import XCTest
@testable import GithubUsers

import RxSwift

final class UserRepositoryTests: XCTestCase {
    private var dummyModel: [UserResponseDTO]!
    private var dummyModelData: Data!
    
    var sut: UserRepositoriable!
    var mockUserStorage: MockUserStorage!
    var stubNetworkService: StubNetworkService!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        dummyModel = [UserResponseDTO(
            login: "",
            id: 1,
            avatarURL: "",
            followersURL: "",
            followingURL: ""
        ), UserResponseDTO(
            login: "",
            id: 2,
            avatarURL: "",
            followersURL: "",
            followingURL: ""
        ), UserResponseDTO(
            login: "",
            id: 3,
            avatarURL: "",
            followersURL: "",
            followingURL: ""
        )]
        dummyModelData = try! JSONEncoder().encode(dummyModel)
        
        mockUserStorage = MockUserStorage()
        stubNetworkService = StubNetworkService(data: dummyModelData)
        sut = UserRepository(userStorage: mockUserStorage, networkService: stubNetworkService)
        
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        dummyModel = nil
        dummyModelData = nil
        mockUserStorage = nil
        stubNetworkService = nil
        sut = nil
        disposeBag = nil
    }
    
    func test_requestUserList를호출할때_유효한데이터를리턴해야한다() {
        // given
        let endpoint = EndpointStorage.users.endPoint
        let expected = dummyModel.map { $0.toDomain() }
        let expectation = XCTestExpectation(description: "requestUserList")
        
        // when
        sut.requestUserList(endpoint)
            .withUnretained(self)
            .subscribe(onNext: { wself, result in
                // then
                XCTAssertEqual(result, expected)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_create를호출할때_callCount가_1올라가야한다() {
        // given
        let expected = 1
        
        // when
        sut.create(User.empty)
        
        // then
        XCTAssertEqual(expected, mockUserStorage.callCount)
        mockUserStorage.verifyStorage()
    }
    
    func test_followingUsersSubject를호출할때_callCount가_1올라가야한다() {
        // given
        let expected = 1
        
        // when
        _ = sut.followingUsersSubject
        
        // then
        XCTAssertEqual(expected, mockUserStorage.callCount)
        mockUserStorage.verifyStorage()
    }
    
    func test_followingObservable를호출할때_callCount가_1올라가야한다() {
        // given
        let expected = 1
        
        // when
        _ = sut.followingObservable()
        
        // then
        XCTAssertEqual(expected, mockUserStorage.callCount)
        mockUserStorage.verifyStorage()
    }
    
    func test_delete를호출할때_callCount가_1올라가야한다() {
        // given
        let expected = 1
        
        // when
        sut.delete(User.empty)
        
        // then
        XCTAssertEqual(expected, mockUserStorage.callCount)
        mockUserStorage.verifyStorage()
    }
}
