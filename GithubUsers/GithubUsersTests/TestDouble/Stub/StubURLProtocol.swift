//
//  StubURLProtocol.swift
//  GithubUsersTests
//
//  Created by 조민호 on 2022/08/14.
//

import Foundation

final class StubURLProtocol: URLProtocol {
    enum DummyResponseType {
        case success(HTTPURLResponse)
        case failure(HTTPURLResponse)
    }
    
    enum DummyDTOType {
        case users
        case followers
        case following
        
        var fileName: String {
            switch self {
            case .users: return "GithubAPI_Users"
            case .followers: return "GithubAPI_Users_Followers"
            case .following: return "GithubAPI_Users_Following"
            }
        }
    }
    
    static var dummyResponseType: DummyResponseType!
    static var dummyDTOType: DummyDTOType!
    
    private let session: URLSession = URLSession.shared
    
    private(set) var activeTask: URLSessionTask?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        let response = dummyResponse()
        let data = StubURLProtocol.dummyData()
        
        client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data!)
        client?.urlProtocolDidFinishLoading(self)
        
        activeTask = session.dataTask(with: request)
        activeTask?.suspend()
        activeTask?.cancel()
    }
    
    override func stopLoading() {
        activeTask?.suspend()
        activeTask?.cancel()
    }
}

extension StubURLProtocol {
    private func dummyResponse() -> HTTPURLResponse? {
        var response: HTTPURLResponse?
        
        switch StubURLProtocol.dummyResponseType {
        case .failure(let newResponse)?:
            response = newResponse
        case .success(let newResponse)?:
            response = newResponse
        default:
            break
        }
        
        return response!
    }
    
    static func dummyData() -> Data? {
        let fileName: String = dummyDTOType.fileName
        let bundle = Bundle(for: NetworkServiceTests.self)
        let path = bundle.path(forResource: fileName, ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        
        return data
    }
    
    static func setupResponseDTOType(with dtoType: DummyDTOType) {
        dummyDTOType = dtoType
    }
    
    static func setupResponseStatusCode(with isSuccess: Bool) {
        if isSuccess {
            dummyResponseType = DummyResponseType
                .success(
                    HTTPURLResponse(
                        url: URL(string: "https://NetworkingSuccess.com")!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )!
                )
        } else {
            dummyResponseType = DummyResponseType
                .failure(
                    HTTPURLResponse(
                        url: URL(string: "https://NetworkingFailure.com")!,
                        statusCode: 404,
                        httpVersion: nil,
                        headerFields: nil
                    )!
                )
        }
    }
}
