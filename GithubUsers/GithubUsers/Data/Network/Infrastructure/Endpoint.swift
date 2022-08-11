//
//  Endpoint.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/11.
//

import Foundation

enum EndpointError: Error {
    case createURLFailure
}

struct Endpoint {
    private let baseURL: String
    private let path: String
    private let method: HTTPMethod
    private let queries: [String: Any]
    private let headers: [String: String]
    private let bodies: Data?
    
    init(
        baseURL: String,
        path: String = "",
        method: HTTPMethod,
        queries: [String: Any] = [:],
        headers: [String: String] = [:],
        bodies: Data? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queries = queries
        self.headers = headers
        self.bodies = bodies
    }
}

extension Endpoint {
    func create() throws -> URLRequest {
        let url = try createURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if method != .get, let httpBody = bodies {
            request.httpBody = httpBody
        }
        
        return request
    }
    
    private func createURL() throws -> URL {
        let urlString = baseURL + path
        var component = URLComponents(string: urlString)
        component?.queryItems = queries.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        
        guard let url = component?.url else {
            throw EndpointError.createURLFailure
        }
        
        return url
    }
}
