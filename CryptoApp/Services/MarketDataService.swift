//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/16/26.
//

import Foundation
import Combine

protocol MarketDataServiceProtocol
{
    var marketData: GlobalData? { get }
    func fetchData(from url: String) async throws
}

@Observable
final class MarketDataService: MarketDataServiceProtocol
{
    private(set) var marketData: GlobalData?
    private var subscribers: Set<AnyCancellable> = []
    
    func fetchData(from url: String) async throws
    {
        guard let url = URL(string: url) else {throw NetworkError.invalidPath}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try NetworkingManager.handleURLResponse(response)
        
        let _marketData = try JSONDecoder().decode(GlobalData.self, from: data)
        self.marketData = _marketData
    }
}
