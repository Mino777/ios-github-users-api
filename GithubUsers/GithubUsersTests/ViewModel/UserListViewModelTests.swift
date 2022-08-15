//
//  UserListViewModelTests.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/15.
//

import XCTest
@testable import GithubUsers

import RxSwift

final class UserListViewModelTests: XCTestCase {
    var dummyUsers: [User]!
    
    var sut: UserListViewModelable!
    var stubUserUseCase: StubUserUseCase!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        dummyUsers = [
            User(
                login: "",
                id: 1,
                avatarURL: "",
                followersURL: "",
                followingURL: "",
                isFollowing: true
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
        
        stubUserUseCase = StubUserUseCase(users: dummyUsers)
        sut = UserListViewModel(useCase: stubUserUseCase)
        
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        dummyUsers = nil
        stubUserUseCase = nil
        sut = nil
        disposeBag = nil
    }
    
    func test_requestUserList를호출할때_users가유효한데이터를가져야한다() {
        // given
        var result: [User] = []
        let expected = dummyUsers
        let expectation = XCTestExpectation(description: "requestUserList")
        
        // when
        sut.requestUserList()
        result = sut.users.value
        expectation.fulfill()
        
        // then
        XCTAssertEqual(result, expected)
        wait(for: [expectation], timeout: 5)
    }
    
    func test_requestUserList를호출할때_실패한경우_showErrorAlertEvent를발생시켜야한다() {
        // given
        stubUserUseCase.isSuccess = false
        var result = ""
        let expected = NetworkServiceError.badRequest.localizedDescription
        let expectation = XCTestExpectation(description: "requestUserList")
        
        // when
        sut.requestUserList()
        sut.state
            .subscribe (onNext: { state in
                switch state {
                case .showErrorAlertEvent(let error):
                    // then
                    result = error
                    XCTAssertEqual(result, expected)
                case .showMyFollowingView:
                    XCTFail()
                }
            })
            .disposed(by: disposeBag)
        expectation.fulfill()
        wait(for: [expectation], timeout: 5)
    }
    
    func test_requestUserList를호출할때_refreshLoading이False이어야한다() {
        // given
        let expected = false
        let expectation = XCTestExpectation(description: "requestUserList")
        
        // when
        sut.requestUserList()
        sut.refreshLoading
            .subscribe { result in
                XCTAssertEqual(result, expected)
                expectation.fulfill()
            } onError: { error in
                XCTFail()
            }
            .disposed(by: disposeBag)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_didTapFollowButton를호출할때_LocalDB가Update되어야한다() {
        // given
        let createdUser = User(
            login: "",
            id: 4,
            avatarURL: "",
            followersURL: "",
            followingURL: "",
            isFollowing: true
        )
        
        let deletedUser = User(
            login: "",
            id: 1,
            avatarURL: "",
            followersURL: "",
            followingURL: "",
            isFollowing: true
        )
        let expectedCreateCase = stubUserUseCase.users.count + 1
        let expectedDeleteCase = stubUserUseCase.users.count
        
        // when, then
        sut.didTapFollowButton(user: createdUser, isFollowing: true)
        XCTAssertEqual(stubUserUseCase.users.count, expectedCreateCase)
        
        sut.didTapFollowButton(user: deletedUser, isFollowing: false)
        XCTAssertEqual(stubUserUseCase.users.count, expectedDeleteCase)
    }
}
