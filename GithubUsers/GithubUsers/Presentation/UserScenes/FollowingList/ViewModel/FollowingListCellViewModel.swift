//
//  FollowingListCellViewModel.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import RxSwift
import RxRelay

protocol FollowingListCellViewModelInput {
    func cellDidBind()
}

protocol FollowingListCellViewModelOutput {
    var userImageEvent: BehaviorRelay<String> { get }
    var userNameEvent: BehaviorRelay<String> { get }
}

protocol FollowingListCellViewModelable: FollowingListCellViewModelInput, FollowingListCellViewModelOutput {}

final class FollowingListCellViewModel: FollowingListCellViewModelable {
    private(set) var user: User
    
    let userImageEvent = BehaviorRelay<String>(value: "")
    let userNameEvent = BehaviorRelay<String>(value: "")
    
    init(user: User) {
        self.user = user
    }
}

extension FollowingListCellViewModel {
    func cellDidBind() {
        userImageEvent.accept(user.avatarURL)
        userNameEvent.accept(user.login)
    }
}
