//
//  UserListView.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import UIKit

import SnapKit

final class UserListView: UIView {
    let userListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: UserListTableViewCell.identifier)
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        addSubview(userListTableView)
    }
    
    private func setupConstraint() {
        userListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
