//
//  UserDetailViewModel.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import RxSwift

enum UserDetailViewModelState {
    
}

protocol UserDetailViewModelInput {
    
}

protocol UserDetailViewModelOutput {

}

protocol UserDetailViewModelable: UserDetailViewModelInput, UserDetailViewModelOutput {}

final class UserDetailViewModel: UserDetailViewModelable {
    private let useCase: UserUseCaseable
    private let user: User
    private let disposeBag = DisposeBag()

    init(useCase: UserUseCaseable, user: User) {
        self.useCase = useCase
        self.user = user
    }
}

extension UserDetailViewModel {

}

