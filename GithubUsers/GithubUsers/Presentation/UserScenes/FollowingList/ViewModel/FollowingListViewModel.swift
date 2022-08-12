//
//  FollowingListViewModel.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import Foundation

import RxSwift
import RxRelay

protocol FollowingListViewModelInput {

}

protocol FollowingListViewModelOutput {

}

protocol FollowingListViewModelable: FollowingListViewModelInput, FollowingListViewModelOutput {}

final class FollowingListViewModel: FollowingListViewModelable {
    private let useCase: UserUseCaseable
    private let disposeBag = DisposeBag()

    init(useCase: UserUseCaseable) {
        self.useCase = useCase
    }
}

extension FollowingListViewModel {

}
