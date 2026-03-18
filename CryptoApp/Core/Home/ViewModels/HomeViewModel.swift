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
    // TODO: remove mock data when done testing
    private(set) var coins: [Coin] = Coin.mockCoins
    private(set) var holdingCoins: [Coin] = Coin.mockHoldings
    private(set) var marketStatistics: [StatisticModel] = StatisticModel.mockStatistics
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
                
                self.marketStatistics = self.makeStatistics(from: marketData)
            }
        }
    }
    
    private func makeStatistics(from data: GlobalData) -> [StatisticModel]
    {
        return [
            .init(title: StatisticModel.Title.marketCap.rawValue,
                  value: data.data.marketCapUSD,
                  percentageChange: data.data.marketCapChangePercentage24hUsd),
            
            .init(title: StatisticModel.Title.dayVolume.rawValue,
                  value: data.data.totalVolumeUSD),
            
            .init(title: StatisticModel.Title.BTCDominance.rawValue,
                  value: data.data.btcDominance),
            
            .init(title: StatisticModel.Title.portfolio.rawValue,
                  value: "0.0",
                  percentageChange: -34.3)
        ]
    }
}


