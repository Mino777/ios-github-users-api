//
//  NetworkServiceError.swift
//  GithubUsers
//
//  Created by 조민호 on 2022/08/11.
//

import Foundation

enum NetworkServiceError: LocalizedError {
    case createURLRequestFailure
    case errorIsOccurred(_ error: String)
    case badRequest
    case unauthorized
    case notFound
    case internalServerError
    case serviceUnavailable
    case invalidateResponse
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .createURLRequestFailure:
            return "잘못된 URL입니다. 고객센터로 연락주세요.\n1111-1111"
        case .errorIsOccurred(let error):
            return "\(error)오류가 발생했습니다. 고객센터로 연락주세요.\n1111-1111"
        case .badRequest:
            return "잘못된 요청입니다. 고객센터로 연락주세요.\n1111-1111"
        case .unauthorized:
            return "유효하지 않은 인증입니다. 고객센터로 연락주세요.\n1111-1111"
        case .notFound:
            return "요청한 페이지를 찾을 수 없습니다. 고객센터로 연락주세요.\n1111-1111"
        case .internalServerError:
            return "현재 서버에 문제가 발생하였습니다. 고객센터로 연락주세요.\n1111-1111"
        case .serviceUnavailable:
            return "현재 서비스 사용이 불가합니다. 고객센터로 연락주세요.\n1111-1111"
        case .invalidateResponse:
            return "유효하지 않은 응답입니다. 고객센터로 연락주세요.\n1111-1111"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다. 고객센터로 연락주세요.\n1111-1111"
        }
    }
}
