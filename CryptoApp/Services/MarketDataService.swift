//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/16/26.
//

import Foundation
import Combine
import FactoryKit

protocol MarketDataServiceProtocol
{
    var marketData: GlobalData? { get }
    func requestData(from endpoin: APIEndpoint) async throws
}

@Observable
final class MarketDataService: MarketDataServiceProtocol
{
    private(set) var marketData: GlobalData?
    private var subscribers: Set<AnyCancellable> = []
    
    @ObservationIgnored
    @Injected(\.networkMonitor) var networkMonitor: NetworkMonitorProtocol

    func requestData(from endpoin: APIEndpoint) async throws
    {
        if !networkMonitor.isReachable
        { try await networkMonitor.waitUntilNetworkIsReachable(withTimeout: 30) }
        
        let path = endpoin.url
        
        switch endpoin
        {
        case .marketData: try await fetchMarketData(from: path)
        default: break
        }
    }
    
    private func fetchMarketData(from url: String) async throws
    {
        guard let url = URL(string: url) else {throw NetworkError.invalidPath}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try NetworkingManager.handleURLResponse(response)
        
        let _marketData = try JSONDecoder().decode(GlobalData.self, from: data)
        self.marketData = _marketData
    }
}
