//
//  CoinService.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//

import Combine
import Foundation

protocol CointServiceProtocol
{
    var coins: CurrentValueSubject<[Coin], Never> { get }
    func fetchCoins(from url: String) throws
}

//@Observable
final class CoinService: CointServiceProtocol
{
    private(set) var coins: CurrentValueSubject<[Coin], Never> = .init([])
    private var subscribers: Set<AnyCancellable> = []
    
    func fetchCoins(from url: String) throws
    {
        guard let url = URL(string: url) else {throw NetworkError.invalidPath}
        
        URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap {
                try NetworkingManager.handleURLResponse($0.response)
                return $0.data
            }
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink {
                NetworkingManager.handleCompletion(completion: $0)
            } receiveValue: { [weak self] coins in
                self?.coins.send(coins)
            }.store(in: &subscribers)
        
    }
}


enum NetworkError: LocalizedError
{
    case invalidPath
    case invalidRespons
    case unauthorized
    case notFound
    case serverError(Int)
    case unexpectedStatusCode(Int)
    
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
        }
    }
}


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
