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

}

protocol UserListViewModelOutput {
    var users: BehaviorRelay<[User]> { get }
}

protocol UserListViewModelable: UserListViewModelInput, UserListViewModelOutput {}

final class UserListViewModel: UserListViewModelable {
    private let useCase: UserUseCaseable
    let users = BehaviorRelay<[User]>(value: User.sampleData())
    
    init(useCase: UserUseCaseable) {
        self.useCase = useCase
    }
}
