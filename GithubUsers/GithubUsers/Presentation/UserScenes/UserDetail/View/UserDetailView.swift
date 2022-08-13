//
//  UserDetailView.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import UIKit

final class UserDetailView: UIView {
    let followStateButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 25)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private let userInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로잉", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    let followerButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로워", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    let followListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserDetailTableViewCell.self, forCellReuseIdentifier: UserDetailTableViewCell.identifier)
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
    }
    
    private func setupView() {
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        addSubview(containerStackView)
        addSubview(followListTableView)
        containerStackView.addArrangeSubviews(userInformationStackView, buttonStackView)
        userInformationStackView.addArrangeSubviews(avatarImageView, userNameLabel)
        buttonStackView.addArrangeSubviews(followingButton, followerButton)
    }
    
    private func setupConstraint() {
        containerStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(containerStackView.snp.height).multipliedBy(0.2)
        }

        followListTableView.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints {
            $0.width.equalTo(containerStackView.snp.width).multipliedBy(0.25)
            $0.height.equalTo(avatarImageView.snp.width)
        }
    }
}
