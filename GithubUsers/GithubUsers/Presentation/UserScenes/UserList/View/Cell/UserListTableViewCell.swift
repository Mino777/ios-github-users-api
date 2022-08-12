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
    private var viewModel: UserListCellViewModelable?
    private(set) var disposeBag = DisposeBag()
    
    private var dataTask: URLSessionDataTask?
    
    var didTapFollowButton: Observable<Void> {
        return followButton.rx.tap.asObservable()
    }
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        dataTask?.suspend()
        dataTask?.cancel()
        disposeBag = DisposeBag()
    }
    
    private func setupView() {
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangeSubviews(avatarImageView, informationStackView)
        informationStackView.addArrangeSubviews(userNameLabel, followButton)
    }
    
    private func setupConstraint() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(10)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.width.equalTo(containerStackView.snp.width).multipliedBy(0.15)
            $0.height.equalTo(avatarImageView.snp.width)
        }
        
        informationStackView.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(5)
        }
        
        followButton.snp.makeConstraints {
            $0.width.equalTo(containerStackView.snp.width).multipliedBy(0.2)
            $0.height.equalTo(containerStackView.snp.height).multipliedBy(0.6)
        }
    }
    
    func bind(_ viewModel: UserListCellViewModelable) {
        self.viewModel = viewModel
        
        followButton.rx.tap
            .asDriver()
            .throttle(.seconds(1))
            .drive(with: self, onNext: { wself, _ in
                wself.changeButtonState(!wself.followButton.isSelected)
                wself.viewModel?.didTapFollowButton()
            }).disposed(by: disposeBag)
        
        viewModel.userImageEvent
            .withUnretained(self)
            .subscribe { wself, url in
                wself.dataTask = wself.avatarImageView.tmon.setImage(url)
            }
            .disposed(by: disposeBag)
        
        viewModel.userNameEvent
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.userFollowingEvent
            .withUnretained(self)
            .subscribe { wself, state in
                wself.changeButtonState(state)
            }
            .disposed(by: disposeBag)
        
        viewModel.cellDidBind()
    }
    
    private func changeButtonState(_ state: Bool) {
        if state {
            followButton.setTitle("언팔로우", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .black
        } else {
            followButton.setTitle("팔로우", for: .normal)
            followButton.setTitleColor(.black, for: .normal)
            followButton.backgroundColor = .white
        }
    }
}
