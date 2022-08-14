//
//  FollowingListView.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

import UIKit

import SnapKit

final class FollowingListView: UIView {
    let followingListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FollowingListTableViewCell.self, forCellReuseIdentifier: FollowingListTableViewCell.identifier)
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
        followingListTableView.rowHeight = frame.size.height * 0.125
    }
    
    private func setupView() {
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        addSubview(followingListTableView)
    }
    
    private func setupConstraint() {
        followingListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

