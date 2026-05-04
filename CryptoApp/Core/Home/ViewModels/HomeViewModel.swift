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
    // MARK: - Stored properties
    private(set) var coins: [Coin] = []
    private(set) var holdingCoins: [Coin] = []
    private(set) var marketStatistics: [StatisticModel] = []
    private(set) var subscribers: Set<AnyCancellable> = []

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
    
    var areCoinsLoading: Bool
    {
        return coins.isEmpty && displayMode == .livePrices
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
                  value: "\(getTotalHoldingsAmount().asCurrencyWithDecimals(maximumFractionDigits: 2))",
                  percentageChange: getPortfolioHoldingsPercentageChange())
        ]
    }
    
    private func getTotalHoldingsAmount() -> Double
    {
        let totalHoldings = holdingCoins.reduce(into: 0.0, { partialResult, coin in
            return partialResult += coin.currentHoldingsValues
        })
        return totalHoldings
    }
    
    private func getPortfolioHoldingsPercentageChange() -> Double
    {
        let previousValues = holdingCoins
            .map { coint  in
                let currentAmount = coint.currentHoldingsValues
                let percentageChange = coint.priceChangePercentage24h ?? 0.0 / 100
                let previousValue = currentAmount / (1 + percentageChange)
                return previousValue
            }
            .reduce(0.0, +)
        
        let percentageCahnge = ((getTotalHoldingsAmount() - previousValues) / previousValues) * 100
        return percentageCahnge
    }
}

//MARK: - Data fetch
extension HomeViewModel
{
    func getCoins() async
    {
        do {
            try await coinService.fetchCoins(from: APIEndpoint.coins.url)
        } catch {
            print("Error getting coins: \(error.localizedDescription)")
        }
    }
    
    func getMarketStats() async
    {
        do {
            try await marketDataService.requestData(from: APIEndpoint.marketData)
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
        /// data market
        observeMarketData()
        
        /// all coins
        coinService.coins
            .filter { !$0.isEmpty }
            .sink { [weak self] coins in
                self?.coins = coins
//                print("Successfully fetched coins: \(coins.first!.id)")
            }.store(in: &subscribers)
        
        /// holdings
        coinService.holdingCoins.sink { holdings in
            self.holdingCoins = holdings
        }.store(in: &subscribers)
    }
    
    private func observeMarketData()
    {
        withObservationTracking {
            _ = marketDataService.marketData
        } onChange: {
            Task { @MainActor in
                defer {
                    self.observeMarketData()
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

//MARK: retrieve db coins
extension HomeViewModel
{
    func retrieveHoldingCoins()
    {
        do {
            let holdings = try database.fetch(type: Coin.self,
                                              filter: Coin.currentHoldingsFilter)
            self.holdingCoins = holdings
        } catch {
            print("🚨 - Error retrieving holdings from DB: \(error.localizedDescription)")
        }
    }
}
