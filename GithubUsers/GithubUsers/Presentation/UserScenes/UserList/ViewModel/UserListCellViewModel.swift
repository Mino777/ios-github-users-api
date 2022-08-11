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
}

protocol UserListCellViewModelOutput {
    var userImageEvent: BehaviorRelay<String> { get }
    var userNameEvent: BehaviorRelay<String> { get }
    var userFollowingEvent: BehaviorRelay<Bool> { get }
}

protocol UserListCellViewModelable: UserListCellViewModelInput, UserListCellViewModelOutput {}

final class UserListCellViewModel: UserListCellViewModelable {
    private let user: User
    
    let userImageEvent = BehaviorRelay<String>(value: "")
    let userNameEvent = BehaviorRelay<String>(value: "")
    let userFollowingEvent = BehaviorRelay<Bool>(value: false)
    
    init(user: User) {
        self.user = user
    }
}

extension UserListCellViewModel {
    func cellDidBind() {
        userImageEvent.accept("swift")
        userNameEvent.accept(user.login)
        userFollowingEvent.accept(user.isFollowing)
    }
}
