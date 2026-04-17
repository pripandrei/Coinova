//
//  NetworkError.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/16/26.
//

import Foundation

enum NetworkError: LocalizedError
{
    case invalidPath
    case invalidRespons
    case unauthorized
    case notFound
    case serverError(Int)
    case unexpectedStatusCode(Int)
    case noInternetConnection
    
    
    var errorDescription: String?
    {
        switch self
        {
        case .invalidPath: return "Invalid path"
        case .invalidRespons: return "Invalid response"
        case .unauthorized: return "Unauthorized"
        case .notFound: return "Not found"
        case .serverError(let code): return "Server error with code: \(code)"
        case .unexpectedStatusCode(let code): return "Unexpected status code: \(code)"
        case .noInternetConnection: return "No internet connection"
        }
    }
}
