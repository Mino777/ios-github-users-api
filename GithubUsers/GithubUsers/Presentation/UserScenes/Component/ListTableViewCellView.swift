//
//  ListTableViewCellView.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import UIKit

import SnapKit

final class ListTableViewCellView: UIView {
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
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
        containerStackView.addArrangeSubviews(avatarImageView, informationStackView)
        informationStackView.addArrangeSubviews(userNameLabel, followButton)
    }
    
    private func setupConstraint() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalTo(self).inset(10)
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
    
    func changeButtonState(_ state: Bool) {
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
