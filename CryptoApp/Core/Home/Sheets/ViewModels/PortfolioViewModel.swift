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
//    var holdingCoins: [Coin] = Coin.mockHoldings
    var holdingCoins: [Coin] = []
    
    private(set) var selectedCoinHoldings: Double?
    private(set) var selectedCoin: Coin?
    
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
    
    var selectedCoinHoldingsAbsoluteValue: Double?
    {
        get {
            selectedCoinHoldings 
        }
        set {
            guard let newValue else { selectedCoinHoldings = newValue; return }
            selectedCoinHoldings = abs(newValue)
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
    
    
    //MARK: - internal functions
    func resetSearch()
    {
        searchQuery = ""
        searchService.reset()
    }
    
    func updateSelectedCoin(_ value: Coin?)
    {
        selectedCoin = value
    }
    
    func getCurrentHoldingsValue() -> Double
    {
        return (selectedCoin?.currentPrice ?? 0.0) * (selectedCoinHoldings ?? 0.0)
    }
}

//MARK: - holdings save
extension PortfolioViewModel
{
    func saveHoldings()
    {
        guard let selectedCoinHoldings,
              let updatedCoin = selectedCoin?.updateHoldings(selectedCoinHoldings) else {return}
        
        localDatabase.save(updatedCoin)
        
        holdingCoins.removeAll(where: { $0.id == updatedCoin.id } )
    
        if selectedCoinHoldings > 0.0
        {
            holdingCoins.append(updatedCoin)
        }
        
        self.selectedCoinHoldings = nil
    }
    
    func updateHoldingAmount(_ value: Double?)
    {
        selectedCoinHoldings = value
    }
}

//MARK: - retrieve holdings
extension PortfolioViewModel
{
    func retrieveHoldingCoins()
    {
        do {
            let holdings = try localDatabase.fetch(type: Coin.self,
                                                   filter: Coin.currentHoldingsFilter)

            self.holdingCoins = holdings
        } catch {
            print("🚨 - Error retrieving holdings from DB: \(error.localizedDescription)")
        }
    }
}

