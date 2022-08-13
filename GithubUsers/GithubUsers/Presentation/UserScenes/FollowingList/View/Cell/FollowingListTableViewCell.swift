//
//  FollowingListTableViewCell.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

final class FollowingListTableViewCell: UITableViewCell {
    private lazy var containerView = ListTableViewCellView()
    private var viewModel: FollowingListCellViewModelable?
    private(set) var disposeBag = DisposeBag()
    
    private var dataTask: URLSessionDataTask?
    
    var didTapUnFollowButton: Observable<Void> {
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
        setupViewAttribute()
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
    }
    
    private func setupConstraint() {
        containerView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
    private func setupViewAttribute() {
        containerView.changeButtonState(true)
        selectionStyle = .none
    }
    
    func bind(_ viewModel: FollowingListCellViewModelable) {
        self.viewModel = viewModel
        
        viewModel.userImageEvent
            .withUnretained(self)
            .subscribe { wself, url in
                wself.dataTask = wself.containerView.avatarImageView.tmon.setImage(url)
            }
            .disposed(by: disposeBag)
        
        viewModel.userNameEvent
            .bind(to: containerView.userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.cellDidBind()
    }
}
