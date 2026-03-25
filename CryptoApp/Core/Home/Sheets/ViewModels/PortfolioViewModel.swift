//
//  Untitled.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/25/26.
//

import Foundation
import FactoryKit

@Observable
final class PortfolioViewModel
{
    var coins: [Coin]
    var holdingCoins: [Coin] = Coin.mockHoldings
    
    //MARK: - Dependencies
    
    @ObservationIgnored
    @Injected(\.searchCoinService) private(set) var searchService
    
    @ObservationIgnored
    @Injected(\.localDatabase) private var localDatabase
    
    //MARK: - init
    init(coins: [Coin]) {
        self.coins = coins
    }
    
    //MARK: - computed properties
    var searchQuery: String = "" {
        didSet
        {
            searchService.search(searchQuery: searchQuery, coins)
        }
    }
    
    var mergedCoins: [Coin]
    {
        guard let searchedCoins = searchService.searchedCoins else
        {
            return holdingCoins
        }
        
        return searchedCoins.map { coin in
            holdingCoins.first(where: { $0.id == coin.id }) ?? coin
        }
    }
    
    func resetSearch()
    {
        searchQuery = ""
        searchService.reset()
    }
}


