//
//  FollowingListViewModelTests.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/15.
//

import XCTest
@testable import GithubUsers

import RxSwift

final class FollowingListViewModelTests: XCTestCase {
    var dummyUsers: [User]!
    
    var sut: FollowingListViewModelable!
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
        sut = FollowingListViewModel(useCase: stubUserUseCase)
        
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        dummyUsers = nil
        stubUserUseCase = nil
        sut = nil
        disposeBag = nil
    }
    
    func test_viewModel이초기화될때_users가유효한데이터를가져야한다() {
        // given
        var result: [User] = []
        let expected = dummyUsers
        let expectation = XCTestExpectation(description: "requestUserList")
        
        // when
        // viewModel init
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
        let expected = StorageError.readFail.localizedDescription
        let expectation = XCTestExpectation(description: "requestUserList")
        
        // when
        // viewModel init
        sut.state
            .subscribe (onNext: { state in
                switch state {
                case .showErrorAlertEvent(let error):
                    // then
                    result = error
                    XCTAssertEqual(result, expected)
                }
            })
            .disposed(by: disposeBag)
        expectation.fulfill()
        wait(for: [expectation], timeout: 5)
    }
    
    func test_didTapUnFollowButton를호출할때_LocalDB가Update되어야한다() {
        // given
        let deletedUser = User(
            login: "",
            id: 1,
            avatarURL: "",
            followersURL: "",
            followingURL: "",
            isFollowing: true
        )
        let expectedDeleteCase = stubUserUseCase.users.count - 1
        
        // when, then
        sut.didTapUnFollowButton(user: deletedUser)
        XCTAssertEqual(stubUserUseCase.users.count, expectedDeleteCase)
    }
}
