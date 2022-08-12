//
//  ExtensionSupport.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/12.
//

struct Extension<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol ExtensionSupport {
    associatedtype Compatible
    var tmon: Extension<Compatible> { get }
    static var tmon: Extension<Compatible>.Type { get }
}

extension ExtensionSupport {
    var tmon: Extension<Self> {
        get {
            return Extension(self)
        }
    }
    
    static var tmon: Extension<Self>.Type {
        get {
            return Extension<Self>.self
        }
    }
}
