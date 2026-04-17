//
//  CoinService.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//

import Combine
import Foundation
import FactoryKit

protocol CointServiceProtocol
{
    var coins: CurrentValueSubject<[Coin], Never> { get }
    var holdingCoins: CurrentValueSubject<[Coin], Never> { get }
    func fetchCoins(from url: String) async throws
    func fetchCoinDetails(from url: String) async throws -> CoinDetail
}


final class CoinService: CointServiceProtocol
{
    private(set) var coins: CurrentValueSubject<[Coin], Never> = .init([])
    private(set) var holdingCoins: CurrentValueSubject<[Coin], Never> = .init([])
    private var subscribers: Set<AnyCancellable> = []
    
    @Injected(\.localDatabase) private var db
    @Injected(\.networkMonitor) private var networkMonitor
    
    init() {
       observeHoldingCoins()
    }
    
    /// coin fetch
    func fetchCoins(from url: String) async throws
    {
        if !networkMonitor.isReachable
        {
            try await networkMonitor.waitUntilNetworkIsReachable(withTimeout: 30)
        }

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
    
    /// coin detail fetch
    func fetchCoinDetails(from url: String) async throws -> CoinDetail
    {
        if !networkMonitor.isReachable
        {
            try await networkMonitor.waitUntilNetworkIsReachable(withTimeout: 30)
        }
        
        guard let url = URL(string: url) else { throw NetworkError.invalidPath}
        
        let (data, urlRespons) = try await URLSession.shared.data(from: url)
        
        try NetworkingManager.handleURLResponse(urlRespons)

        let details = try JSONDecoder().decode(CoinDetail.self, from: data)
        return details
    }
    
    /// observers
    private func observeHoldingCoins()
    {
        db.observe(type: Coin.self,
                   filter: Coin.currentHoldingsFilter)
        .sink { NetworkingManager.handleCompletion(completion: $0) }
        receiveValue: { holdingCoins in
            self.holdingCoins.send(holdingCoins)
        }.store(in: &subscribers)
    }
}


