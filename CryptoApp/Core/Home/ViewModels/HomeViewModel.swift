//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//


import Foundation
import Combine
import FactoryKit

@Observable
final class HomeViewModel: HomeViewModelProtocol
{
    private(set) var coins: [Coin] = []
    private(set) var holdingCoins: [Coin] = Coin.mockHoldings
    private(set) var marketStatistics: [StatisticModel] = [
            .init(title: StatisticModel.Title.marketCap.rawValue,
                  value: 6_623_640_000.32323.abbreviated(),
                  percentageChange: 12.3),
            .init(title: StatisticModel.Title.dayVolume.rawValue,
                  value: 3_640_000.47.abbreviated()),
            .init(title: StatisticModel.Title.BTCDominance.rawValue,
                  value: 54.34554.asPercentWithDecimals()),
            .init(title: StatisticModel.Title.portfolio.rawValue,
                  value: 834.3434.abbreviated(),
                  percentageChange: -3.0)
    ]
    private var subscribers: Set<AnyCancellable> = []
    
    @ObservationIgnored
    @Injected(\.coinService) private var coinService
    @ObservationIgnored
    @Injected(\.marketDataService) private var marketDataService
    
    func getCoins()
    {
        do {
            try coinService.fetchCoins(from: APIEndpoint.coins.url)
        } catch {
            print("Error getting coins: \(error.localizedDescription)")
        }
    }
    
    func getMarketStats() async
    {
        do {
            try await marketDataService.fetchData(from: APIEndpoint.marketData.url)
        } catch {
            print("Error getting market stats: \(error.localizedDescription)")
        }
    }
    
    func setupBindings()
    {
        observe()
        
        coinService.coins
            .filter { !$0.isEmpty }
            .sink { [weak self] coins in
                self?.coins = Array(coins.prefix(15))
                print("Coinsssss: \(self!.coins)")
//                print("Successfully fetched coins: \(coins.first!.id)")
//                coins.forEach { coin in
//                    print("======== New coin: \(coin) \n")
//                }
            }.store(in: &subscribers)
    }
    
     func observe()
    {
        withObservationTracking {
            _ = marketDataService.marketData
        } onChange: {
            Task { @MainActor in
                defer {
                    self.observe()
                }
                guard let marketData = self.marketDataService.marketData else {return}

                self.marketStatistics = [
                    .init(title: StatisticModel.Title.marketCap.rawValue,
                          value: marketData.data.marketCapUSD,
                          percentageChange: marketData.data.marketCapChangePercentage24hUsd),
                    .init(title: StatisticModel.Title.dayVolume.rawValue,
                          value: marketData.data.totalVolumeUSD),
                    .init(title: StatisticModel.Title.BTCDominance.rawValue,
                          value: marketData.data.btcDominance),
                    .init(title: StatisticModel.Title.portfolio.rawValue,
                          value: "0.0", percentageChange: -34.3)
                ]
            }
        }
    }
}


