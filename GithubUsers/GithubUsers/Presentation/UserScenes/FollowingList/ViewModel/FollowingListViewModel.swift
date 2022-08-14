//
//  FollowingListViewModel.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import Foundation

import RxSwift
import RxRelay

enum FollowingListViewModelState {
    case showErrorAlertEvent(error: String)
}

protocol FollowingListViewModelInput {
    func didTapUnFollowButton(user: User)
}

protocol FollowingListViewModelOutput {
    var state: PublishSubject<FollowingListViewModelState> { get }
    var users: BehaviorRelay<[User]> { get }
}

protocol FollowingListViewModelable: FollowingListViewModelInput, FollowingListViewModelOutput {}

final class FollowingListViewModel: FollowingListViewModelable {
    private let useCase: UserUseCaseable
    private let disposeBag = DisposeBag()

    // MARK: Output
    
    let state = PublishSubject<FollowingListViewModelState>()
    let users = BehaviorRelay<[User]>(value: [])
    
    init(useCase: UserUseCaseable) {
        self.useCase = useCase
        retrieveFollowingUsers(useCase.followingUsersSubject)
    }
    
    private func retrieveFollowingUsers(_ userStorageState: Observable<UserStorageState>) {
        userStorageState
            .withUnretained(self)
            .flatMap { wself, state -> Observable<[User]> in
                switch state {
                case .success(let items):
                    return .just(items)
                case .failure(let error):
                    wself.state.onNext(.showErrorAlertEvent(error: error.localizedDescription))
                    return .just([])
                }
            }
            .withUnretained(self)
            .subscribe { wself, users in
                wself.users.accept(users)
            }.disposed(by: disposeBag)
    }
}

// MARK: Input

extension FollowingListViewModel {
    func didTapUnFollowButton(user: User) {
        deleteUserInLocalDatabase(user)
    }
    
    private func deleteUserInLocalDatabase(_ user: User) {
        let updatedUser = User(
            login: user.login,
            id: user.id,
            avatarURL: user.avatarURL,
            followersURL: user.followersURL,
            followingURL: user.followingURL,
            isFollowing: false
        )
        
        useCase.delete(updatedUser)
    }
}
