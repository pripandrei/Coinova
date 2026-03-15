//
//  NetworkingManager.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/15/26.
//

import Foundation
import Combine

final class NetworkingManager
{
    static func handleURLResponse(_ response: URLResponse) throws
    {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRespons
        }
        
        switch response.statusCode
        {
        case 200...300: break
        case 401: throw NetworkError.unauthorized
        case 404: throw NetworkError.notFound
        case 500..<599: throw NetworkError.serverError(response.statusCode)
        default: throw NetworkError.unexpectedStatusCode(response.statusCode)
        }
    }
    
    static func handleCompletion(completion: Subscribers.Completion<any Error>)
    {
        switch completion
        {
        case .finished: break
        case .failure(let error): print("Error: \(error.localizedDescription)")
        }
    }
}
