//
//  UserDetailViewModel.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import RxSwift
import RxRelay

enum UserDetailViewModelState {
    case showErrorAlertEvent(error: String)
}

protocol UserDetailViewModelInput {
    func viewDidBind()
    func requestFollowingList()
    func requestFollowerList()
    func didTapFollowButton()
    var refreshLoading: PublishRelay<Bool> { get }
}

protocol UserDetailViewModelOutput {
    var state: PublishSubject<UserDetailViewModelState> { get }
    var users: BehaviorRelay<[User]> { get }
    var userImageEvent: BehaviorRelay<String> { get }
    var userNameEvent: BehaviorRelay<String> { get }
    var isFollwoing: BehaviorRelay<Bool> { get }
    var userFollowingState: PublishRelay<Bool> { get }
}

protocol UserDetailViewModelable: UserDetailViewModelInput, UserDetailViewModelOutput {}

final class UserDetailViewModel: UserDetailViewModelable {
    private let useCase: UserUseCaseable
    private(set) var user: User
    private let disposeBag = DisposeBag()

    let state = PublishSubject<UserDetailViewModelState>()
    let users = BehaviorRelay<[User]>(value: [])
    
    let userImageEvent = BehaviorRelay<String>(value: "")
    let userNameEvent = BehaviorRelay<String>(value: "")
    
    let refreshLoading = PublishRelay<Bool>()
    let isFollwoing = BehaviorRelay<Bool>(value: true)
    let userFollowingState = PublishRelay<Bool>()
    
    init(useCase: UserUseCaseable, user: User) {
        self.useCase = useCase
        self.user = user
    }
}

extension UserDetailViewModel {
    func viewDidBind() {
        requestFollowingList()
        userImageEvent.accept(user.avatarURL)
        userNameEvent.accept(user.login)
        userFollowingState.accept(user.isFollowing)
    }
    
    func requestFollowingList() {
        useCase.requestFollowingList(user.followingURL)
            .subscribe(with: self) { wself, result in
                wself.users.accept(result)
                wself.refreshLoading.accept(false)
                wself.isFollwoing.accept(true)
            } onError: { wself, error in
                wself.state.onNext(.showErrorAlertEvent(error: error.localizedDescription))
                wself.refreshLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func requestFollowerList() {
        useCase.requestFollowerList(user.followersURL)
            .subscribe(with: self) { wself, result in
                wself.users.accept(result)
                wself.refreshLoading.accept(false)
                wself.isFollwoing.accept(false)
            } onError: { wself, error in
                wself.state.onNext(.showErrorAlertEvent(error: error.localizedDescription))
                wself.refreshLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func didTapFollowButton() {
        user.isFollowing.toggle()
        
        let updatedUser = User(
            login: user.login,
            id: user.id,
            avatarURL: user.avatarURL,
            followersURL: user.followersURL,
            followingURL: user.followingURL,
            isFollowing: user.isFollowing
        )
        
        if user.isFollowing {
            useCase.create(updatedUser)
        } else {
            useCase.delete(updatedUser)
        }
        
        userFollowingState.accept(user.isFollowing)
    }
}

