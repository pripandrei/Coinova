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
}
