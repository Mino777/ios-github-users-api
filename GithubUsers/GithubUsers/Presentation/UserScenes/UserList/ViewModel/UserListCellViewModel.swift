//
//  UserListCellViewModel.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/11.
//

import RxSwift
import RxRelay

protocol UserListCellViewModelInput {
    func cellDidBind()
    func didTapFollowButton()
}

protocol UserListCellViewModelOutput {
    var userImageEvent: BehaviorRelay<String> { get }
    var userNameEvent: BehaviorRelay<String> { get }
    var userFollowingEvent: BehaviorRelay<Bool> { get }
}

protocol UserListCellViewModelable: UserListCellViewModelInput, UserListCellViewModelOutput {}

final class UserListCellViewModel: UserListCellViewModelable {
    private(set) var user: User
    
    // MARK: Output
    
    let userImageEvent = BehaviorRelay<String>(value: "")
    let userNameEvent = BehaviorRelay<String>(value: "")
    let userFollowingEvent = BehaviorRelay<Bool>(value: false)
    
    init(user: User) {
        self.user = user
    }
}

// MARK: Input

extension UserListCellViewModel {
    func cellDidBind() {
        setupData()
    }
    
    func didTapFollowButton() {
        setupFollowing()
    }
    
    private func setupData() {
        userImageEvent.accept(user.avatarURL)
        userNameEvent.accept(user.login)
        userFollowingEvent.accept(user.isFollowing)
    }
    
    private func setupFollowing() {
        user.isFollowing.toggle()
        userFollowingEvent.accept(user.isFollowing)
    }
}
