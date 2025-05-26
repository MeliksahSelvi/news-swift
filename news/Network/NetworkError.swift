//
//  NetworkError.swift
//  news
//
//  Created by Melik on 24.05.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case decodingError
    case invalidData
    case requestFailedWith(Int)
    case customError(Error)

    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "Invalid response"   
        case .decodingError:
            return "Decoding error"
        case .invalidData:
            return "Invalid data"
        case .requestFailedWith(let statusCode):
            return "Request failed with status code: \(statusCode)"
        case .customError(let error):
            return "An error occurred: \(error.localizedDescription)"
        }
    }
}

