//
//  UserListViewModel.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

enum UserListViewModelState {

}

protocol UserListViewModelInput {

}

protocol UserListViewModelOutput {

}

protocol UserListViewModelable: UserListViewModelInput, UserListViewModelOutput {}

final class UserListViewModel: UserListViewModelable {
    
    private let useCase: UserUseCaseable
    
    init(useCase: UserUseCaseable) {
        self.useCase = useCase
    }
}
