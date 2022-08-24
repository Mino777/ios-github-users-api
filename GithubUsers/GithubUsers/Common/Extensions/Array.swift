//
//  Array.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/13.
//

import Foundation

extension Array {
  subscript (safe index: Int) -> Element? {
    return self.indices ~= index ? self[index] : nil
  }
}
