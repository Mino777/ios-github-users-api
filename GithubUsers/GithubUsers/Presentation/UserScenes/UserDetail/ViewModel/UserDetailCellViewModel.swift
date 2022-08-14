//
//  UserDetailCellViewModel.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import RxSwift
import RxRelay

protocol UserDetailCellViewModelInput {
    func cellDidBind()
}

protocol UserDetailCellViewModelOutput {
    var userImageEvent: BehaviorRelay<String> { get }
    var userNameEvent: BehaviorRelay<String> { get }
}

protocol UserDetailCellViewModelable: UserDetailCellViewModelInput, FollowingListCellViewModelOutput {}

final class UserDetailCellViewModel: UserDetailCellViewModelable {
    private(set) var user: User
    
    // MARK: Output
    
    let userImageEvent = BehaviorRelay<String>(value: "")
    let userNameEvent = BehaviorRelay<String>(value: "")
    
    init(user: User) {
        self.user = user
    }
}

// MARK: Input

extension UserDetailCellViewModel {
    func cellDidBind() {
        setupData()
    }
    
    private func setupData() {
        userImageEvent.accept(user.avatarURL)
        userNameEvent.accept(user.login)
    }
}
