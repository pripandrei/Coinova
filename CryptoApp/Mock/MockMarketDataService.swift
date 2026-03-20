//
//  MockMarketDataService.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/20/26.
//

#if DEBUG
import Foundation

@Observable
final class MockMarketDataService: MarketDataServiceProtocol
{
    var marketData: GlobalData?
    
    func fetchData(from url: String) async throws
    {
        self.marketData = GlobalData.mockData
    }
}


//MARK: - Mock
extension GlobalData
{
    static var mockMarketData: MarketData = .init(
        totalMarketCap: ["usd": 6_623_640_000.32323],
        totalVolume: ["usd": 3_640_000.47],
        marketCapPercentage: ["btc": 54.34554],
        marketCapChangePercentage24hUsd:
            -3.0
    )
    
    static var mockData: GlobalData = .init(data: Self.mockMarketData)
}

#endif // DEBUG

