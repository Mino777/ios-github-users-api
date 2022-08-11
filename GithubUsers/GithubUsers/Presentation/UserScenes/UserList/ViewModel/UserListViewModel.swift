//
//  UserListViewModel.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import RxSwift
import RxRelay

enum UserListViewModelState {

}

protocol UserListViewModelInput {
    func requestUserList()
    func didTapFollowButton(user: User, isFollowing: Bool)
}

protocol UserListViewModelOutput {
    var users: BehaviorRelay<[User]> { get }
}

protocol UserListViewModelable: UserListViewModelInput, UserListViewModelOutput {}

final class UserListViewModel: UserListViewModelable {
    private let useCase: UserUseCaseable
    private let disposeBag = DisposeBag()
    let users = BehaviorRelay<[User]>(value: [])
    
    init(useCase: UserUseCaseable) {
        self.useCase = useCase
    }
}

extension UserListViewModel {
    func requestUserList() {
        useCase.requestUserList()
            .withUnretained(self)
            .subscribe { wself, result in
                wself.users.accept(result)
            } onError: { error in
                print(error)
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
}
