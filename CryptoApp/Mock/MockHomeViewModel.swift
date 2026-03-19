//
//  MockHomeViewModel.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/17/26.
//


#if DEBUG

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var coins: [Coin] {get}
    var marketStatistics: [StatisticModel] {get}
    
    func getCoins()
    func getMarketStats() async
}

@Observable
final class MockHomeViewModel: HomeViewModelProtocol
{
    var coins: [Coin] = []
    var marketStatistics: [StatisticModel] = []
    
    func getCoins() {
        self.coins = [DeveloperPreview.instance.coin]
    }
    
    init() {
        getCoins()
        Task
        {
            await getMarketStats()
        }
    }
    
    func getMarketStats() async
    {
        self.marketStatistics = [
            .init(title: StatisticModel.Title.marketCap.rawValue,
                  value: "77123214.3",
                  percentageChange: 2.4),
            .init(title: StatisticModel.Title.dayVolume.rawValue,
                  value: "$6632424.34"),
            .init(title: StatisticModel.Title.BTCDominance.rawValue,
                  value: "823421.2%"),
            .init(title: StatisticModel.Title.portfolio.rawValue,
                  value: "230.34", percentageChange: -3)
        ]
    }
    
    func observe() {
        
    }
}

#endif
