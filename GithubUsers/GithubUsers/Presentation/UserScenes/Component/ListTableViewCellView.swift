//
//  ListTableViewCellView.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import UIKit

import SnapKit

final class ListTableViewCellView: UIView {
    private enum Constants {
        static let unFollow = "언팔로우"
        static let follow = "팔로우"
    }
    
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
        label.font = .preferredFont(forTextStyle: .title3)
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
            $0.edges.equalToSuperview().inset(10)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.height.equalTo(containerStackView.snp.height)
            $0.width.equalTo(avatarImageView.snp.height)
        }

        followButton.snp.makeConstraints {
            $0.width.equalTo(containerStackView.snp.width).multipliedBy(0.2)
            $0.height.equalTo(containerStackView.snp.height).multipliedBy(0.6)
        }
    }
    
    func changeButtonState(_ state: Bool) {
        if state {
            followButton.setTitle(Constants.unFollow, for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .black
        } else {
            followButton.setTitle(Constants.follow, for: .normal)
            followButton.setTitleColor(.black, for: .normal)
            followButton.backgroundColor = .white
        }
    }
}
