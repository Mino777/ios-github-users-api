//
//  UserListTableViewCell.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

final class UserListTableViewCell: UITableViewCell {
    private lazy var containerView = UserListTableViewCellView()
    private var viewModel: UserListCellViewModelable?
    private(set) var disposeBag = DisposeBag()
    
    private var dataTask: URLSessionDataTask?
    
    var didTapFollowButton: Observable<Void> {
        return containerView.followButton.rx.tap.asObservable()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.avatarImageView.image = nil
        dataTask?.suspend()
        dataTask?.cancel()
        disposeBag = DisposeBag()
    }
    
    private func setupView() {
        addSubviews()
        setupConstraint()
    }
    private func addSubviews() {
        contentView.addSubview(containerView)
    }
    
    private func setupConstraint() {
        containerView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
    func bind(_ viewModel: UserListCellViewModelable) {
        self.viewModel = viewModel
        
        containerView.followButton.rx.tap
            .asDriver()
            .throttle(.seconds(1))
            .drive(with: self, onNext: { wself, _ in
                wself.containerView.changeButtonState(!wself.containerView.followButton.isSelected)
                wself.viewModel?.didTapFollowButton()
            }).disposed(by: disposeBag)
        
        viewModel.userImageEvent
            .withUnretained(self)
            .subscribe { wself, url in
                wself.dataTask = wself.containerView.avatarImageView.tmon.setImage(url)
            }
            .disposed(by: disposeBag)
        
        viewModel.userNameEvent
            .bind(to: containerView.userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userFollowingEvent
            .withUnretained(self)
            .subscribe { wself, state in
                wself.containerView.changeButtonState(state)
            }
            .disposed(by: disposeBag)
        
        viewModel.cellDidBind()
    }
}
