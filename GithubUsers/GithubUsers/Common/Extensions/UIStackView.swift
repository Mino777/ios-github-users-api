//
//  UIStackView.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/10.
//

import UIKit

extension UIStackView {
    
    func addArrangeSubviews(_ views: UIView...) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}
