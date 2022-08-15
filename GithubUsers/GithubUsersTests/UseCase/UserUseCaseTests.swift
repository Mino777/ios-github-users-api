//
//  UserUseCaseTests.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/15.
//

import XCTest
@testable import GithubUsers

import RxSwift

final class UserUseCaseTests: XCTestCase {
    var dummyFollowingUsers: [User]!
    var dummyAllUsers: [User]!
    
    var sut: UserUseCaseable!
    var mockUserReposiotry: MockUserRepository!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        dummyFollowingUsers = [
            User(
                login: "",
                id: 1,
                avatarURL: "",
                followersURL: "",
                followingURL: "",
                isFollowing: true
            ),User(
                login: "",
                id: 3,
                avatarURL: "",
                followersURL: "",
                followingURL: "",
                isFollowing: true
            )
        ]
        
        dummyAllUsers = [
            User(
                login: "",
                id: 1,
                avatarURL: "",
                followersURL: "",
                followingURL: "",
                isFollowing: false
            ),User(
                login: "",
                id: 2,
                avatarURL: "",
                followersURL: "",
                followingURL: "",
                isFollowing: false
            ),User(
                login: "",
                id: 3,
                avatarURL: "",
                followersURL: "",
                followingURL: "",
                isFollowing: false
            )
        ]
        
        mockUserReposiotry = MockUserRepository(followingUsers: dummyFollowingUsers, allUsers: dummyAllUsers)
        sut = UserUseCase(userRepository: mockUserReposiotry)
        
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        dummyFollowingUsers = nil
        dummyAllUsers = nil
        mockUserReposiotry = nil
        sut = nil
        disposeBag = nil
    }
    
    func test_requestUserList를호출할때_유효한데이터를리턴해야한다() {
        // given
        let expected1 = dummyFollowingUsers[0].isFollowing
        let expected2 = dummyFollowingUsers[1].isFollowing
        let expectation = XCTestExpectation(description: "requestUserList")
        
        // when
        sut.requestUserList()
            .subscribe(onNext: { result in
                // then
                XCTAssertEqual(result[0].isFollowing, expected1)
                XCTAssertEqual(result[2].isFollowing, expected2)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_requestFollowerList를호출할때_callCount가_1증가해야한다() {
        // given
        let expected = 1
        
        // when
        _ = sut.requestFollowerList("")
        
        // then
        XCTAssertEqual(expected, mockUserReposiotry.callCount)
    }
    
    func test_requestFollowingList를호출할때_callCount가_1증가해야한다() {
        // given
        let expected = 1
        
        // when
        _ = sut.requestFollowingList("")
        
        // then
        XCTAssertEqual(expected, mockUserReposiotry.callCount)
    }
    
    func test_create를호출할때_callCount가_1증가해야한다() {
        // given
        let expected = 1
        
        // when
        _ = sut.create(User.empty)
        
        // then
        XCTAssertEqual(expected, mockUserReposiotry.callCount)
    }
    
    func test_followingUsersSubject를호출할때_callCount가_1증가해야한다() {
        // given
        let expected = 1
        
        // when
        _ = sut.followingUsersSubject
        
        // then
        XCTAssertEqual(expected, mockUserReposiotry.callCount)
    }
    
    func test_delete를호출할때_callCount가_1증가해야한다() {
        // given
        let expected = 1
        
        // when
        _ = sut.delete(User.empty)
        
        // then
        XCTAssertEqual(expected, mockUserReposiotry.callCount)
    }
}
