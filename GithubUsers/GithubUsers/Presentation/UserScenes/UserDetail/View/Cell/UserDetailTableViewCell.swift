//
//  UserDetailTableViewCell.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

final class UserDetailTableViewCell: UITableViewCell {
    private lazy var containerView = ListTableViewCellView()
    private var viewModel: UserDetailCellViewModelable?
    private(set) var disposeBag = DisposeBag()
    
    private var dataTask: URLSessionDataTask?

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
        selectionStyle = .none
        containerView.followButton.isHidden = true
    }
    
    func bind(_ viewModel: UserDetailCellViewModelable) {
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


