//
//  NetworkService.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/11.
//

import Foundation

import RxSwift

protocol NetworkServiceable: AnyObject {
    func request(endpoint: Endpoint) -> Observable<Data>
}

final class NetworkService: NetworkServiceable {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request(endpoint: Endpoint) -> Observable<Data> {
        return Single<Data>.create { [weak self] single in
            guard let urlRequest = try? endpoint.create() else {
                single(.failure(NetworkServiceError.createURLRequestFailure))
                return Disposables.create()
            }
            
            let task = self?.urlSession.dataTask(with: urlRequest) { data, response, error in
                guard error == nil, let data = data else {
                    single(.failure(NetworkServiceError.errorIsOccurred(error.debugDescription)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    single(.failure(NetworkServiceError.invalidateResponse))
                    return
                }
                
                switch response.statusCode {
                case 200..<300: single(.success(data))
                case 400: single(.failure(NetworkServiceError.badRequest))
                case 401: single(.failure(NetworkServiceError.unauthorized))
                case 404: single(.failure(NetworkServiceError.notFound))
                case 500: single(.failure(NetworkServiceError.internalServerError))
                case 503: single(.failure(NetworkServiceError.serviceUnavailable))
                default: single(.failure(NetworkServiceError.unknown))
                }
            }
            task?.resume()
            
            return Disposables.create {
                task?.suspend()
                task?.cancel()
            }
        }.asObservable()
    }
}
