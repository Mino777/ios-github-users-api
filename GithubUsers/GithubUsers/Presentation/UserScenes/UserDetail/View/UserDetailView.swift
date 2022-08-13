//
//  UserDetailView.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import UIKit

final class UserDetailView: UIView {
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
    
    private func setupView() {
        backgroundColor = .white
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        addSubview(followListTableView)
    }
    
    private func setupConstraint() {
        followListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
