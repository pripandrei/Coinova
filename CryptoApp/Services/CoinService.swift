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


