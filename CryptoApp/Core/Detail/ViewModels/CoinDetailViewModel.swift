//
//  CoinDetailViewModel.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/1/26.
//

import Foundation
import FactoryKit

@Observable
final class CoinDetailViewModel
{
    let coin: Coin
    private(set) var coinDetails: CoinDetail?
    
    private(set) var overview: [StatisticModel] = []
    private(set) var additionalDetails: [StatisticModel] = []
    
    @ObservationIgnored
    @Injected(\.coinService) var coinService
    
    init(coin: Coin)
    {
        self.coin = coin
    }
    
    func getCoinDetails() async throws
    {
        guard coinDetails == nil else {return}
        
        let path = APIEndpoint.coinDetails(id: self.coin.id).url
        self.coinDetails = try await coinService.fetchCoinDetails(from: path)
    }
    
    func createDataStats()
    {
        self.overview = createOverviewData()
        self.additionalDetails = createAdditionalDetailsData()
    }
    
    private func createOverviewData() -> [StatisticModel]
    {
        let currentPrice = StatisticModel(title: coin.getTitle(from: .currentPrice),
                                          value: coin.currentPrice.asCurrenyWithDecimals(),
                                          percentageChange: 0.0)
        let marketCap = StatisticModel(title: coin.getTitle(from: .marketCap),
                                       value: "$" + (coin.marketCap?.abbreviated() ?? "0.0"),
                                       percentageChange: 0.0)
        let rank = StatisticModel(title: coin.getTitle(from: .marketCapRank).lastWord,
                                  value: "\(coin.marketCapRank ?? 0)")
        let volume = StatisticModel(title: coin.getTitle(from: .totalVolume).lastWord,
                                    value: "$" + (coin.totalVolume?.abbreviated() ?? "0.0"),
                                    percentageChange: 0.0)
        
        return [currentPrice, marketCap, rank, volume]
    }
    
    private func createAdditionalDetailsData() -> [StatisticModel]
    {
        
        return []
    }
    
}
