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
final class HomeViewModel
{
    // TODO: remove mock data when done testing
    // MARK: - Stored properties
    private(set) var coins: [Coin] = []
//    private(set) var holdingCoins: [Coin] = Coin.mockHoldings
    private(set) var holdingCoins: [Coin] = []
    private(set) var marketStatistics: [StatisticModel] = []
    private var subscribers: Set<AnyCancellable> = []
    private var searchTask: Task<Void, Never>?
    
    // MARK: - computed properties
    var coinSortOption: CoinSortOption = .minRank
    {
        didSet
        {
            filterCoins()
        }
    }
    
    var displayMode: HomeDisplayMode = .livePrices
    {
        didSet
        {
            if !searchQuery.isEmpty { searchForCoins() }
        }
    }
    
    var searchQuery: String = ""
    {
        didSet {
            guard oldValue != searchQuery else {return}
            searchForCoins()
        }
    }
    
    // MARK: - Dependencies
    
    @ObservationIgnored
    @Injected(\.searchCoinService) private(set) var searchService
    
    @ObservationIgnored
    @Injected(\.localDatabase) private var database
    
    @ObservationIgnored
    @Injected(\.coinService) private var coinService
    
    @ObservationIgnored
    @Injected(\.marketDataService) private var marketDataService
 
    // MARK: - stats creation
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

//MARK: - Data fetch
extension HomeViewModel
{
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
}

//MARK: -  Subscribers
extension HomeViewModel
{
    func setupSubscribers()
    {
        observe()
        
        coinService.coins
            .filter { !$0.isEmpty }
            .sink { [weak self] coins in
                self?.coins = coins
//                print("Successfully fetched coins: \(coins.first!.id)")
            }.store(in: &subscribers)
    }
    
    private func observe()
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
}


//MARK: - Filter coins
extension HomeViewModel
{
    func filterCoins()
    {
        let sortCoins = displayMode == .livePrices

        switch coinSortOption
        {
        case .maxRank:
            sortCoins
                ? self.coins.sort { $0.marketCapRank ?? 0 > $1.marketCapRank ?? 0 }
                : self.holdingCoins.sort { $0.marketCapRank ?? 0 > $1.marketCapRank ?? 0 }
        case .minRank:
            sortCoins
                ? self.coins.sort { $0.marketCapRank ?? 0 < $1.marketCapRank ?? 0 }
                : self.holdingCoins.sort { $0.marketCapRank ?? 0 < $1.marketCapRank ?? 0 }
        case .maxPrice:
            sortCoins
                ? self.coins.sort { $0.currentPrice > $1.currentPrice }
                : self.holdingCoins.sort { $0.currentPrice > $1.currentPrice }
        case .minPrice:
            sortCoins
                ? self.coins.sort { $0.currentPrice < $1.currentPrice }
                : self.holdingCoins.sort { $0.currentPrice < $1.currentPrice }
        case .maxHoldings:
            self.holdingCoins.sort { $0.currentHoldings ?? 0 > $1.currentHoldings ?? 0 }
        case .minHoldings:
            self.holdingCoins.sort { $0.currentHoldings ?? 0 < $1.currentHoldings ?? 0 }
        }
    }
}

//MARK: Search coins
extension HomeViewModel
{
    private func searchForCoins()
    {
        let coins = displayMode == .livePrices ? self.coins : self.holdingCoins
        searchService.search(searchQuery: self.searchQuery, coins)
    }
    
    func resetSearch()
    {
        searchQuery = ""
        searchService.reset()
    }
}
