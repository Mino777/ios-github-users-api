//
//  UserListViewModel.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import Foundation

import RxSwift
import RxRelay

enum UserListViewModelState {
    case showErrorAlertEvent(error: String)
    case showMyFollowingView
}

protocol UserListViewModelInput {
    func requestUserList()
    func didTapFollowButton(user: User, isFollowing: Bool)
    func showMyFollowingView()
    var refreshLoading: PublishRelay<Bool> { get }
}

protocol UserListViewModelOutput {
    var state: PublishSubject<UserListViewModelState> { get }
    var users: BehaviorRelay<[User]> { get }
}

protocol UserListViewModelable: UserListViewModelInput, UserListViewModelOutput {}

final class UserListViewModel: UserListViewModelable {
    private let useCase: UserUseCaseable
    private let disposeBag = DisposeBag()
    
    let state = PublishSubject<UserListViewModelState>()
    let users = BehaviorRelay<[User]>(value: [])
    
    let refreshLoading = PublishRelay<Bool>()
    
    init(useCase: UserUseCaseable) {
        self.useCase = useCase
    }
}

extension UserListViewModel {
    func requestUserList() {
        useCase.requestUserList()
            .subscribe(with: self) { wself, result in
                wself.users.accept(result)
                wself.refreshLoading.accept(false)
            } onError: { wself, error in
                wself.state.onNext(.showErrorAlertEvent(error: error.localizedDescription))
                wself.refreshLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func didTapFollowButton(user: User, isFollowing: Bool) {
        let updatedUser = User(
            login: user.login,
            id: user.id,
            avatarURL: user.avatarURL,
            followersURL: user.followersURL,
            followingURL: user.followingURL,
            isFollowing: isFollowing
        )
        
        if isFollowing {
            useCase.create(updatedUser)
        } else {
            useCase.delete(updatedUser)
        }
    }
    
    func showMyFollowingView() {
        state.onNext(.showMyFollowingView)
    }
}
