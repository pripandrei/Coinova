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
    
    private var selectedCoinHoldings: Double?
    private(set) var selectedCoin: Coin?
    
    //MARK: - Dependencies
    
    @ObservationIgnored
    @Injected(\.searchCoinService) private(set) var searchService
    
    @ObservationIgnored
    @Injected(\.localDatabase) private var localDatabase
    
    //MARK: - init
    init(coins: [Coin]) {
        self.coins = coins
        retrieveHoldingCoins() // TODO: - move when done testing
//        saveTest()
    }
    
    //MARK: - computed properties
    var searchQuery: String = "" {
        didSet
        {
            searchService.search(searchQuery: searchQuery, coins)
        }
    }
    
    var selectedCoinHoldingsAbsoluteValue: Double
    {
        get {
            selectedCoinHoldings ?? 0.0
        }
        set {
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
        
        if let index = holdingCoins.firstIndex(where: { $0.id == updatedCoin.id })
        {
            holdingCoins.remove(at: index)
        }
        holdingCoins.append(updatedCoin)
    }
    
    func updateHoldingAmount(_ value: Double?)
    {
        selectedCoinHoldings = value
    }
}

//import GRDB
//MARK: - retrieve holdings
extension PortfolioViewModel
{
    
    func saveTest()
    {
        if let coin = coins.first(where: { $0.marketCapRank == 174} )
        {
            print("found coin: \(coin.id)")
            localDatabase.save(coin)
        }
        
    }
    func retrieveHoldingCoins()
    {
//        let filter = Coin.currentHoldingsFilter && Coin.topRank
        let filter = Coin.currentHoldingsFilter
        let filter2 = Coin.topRank
//        let asd = Column(Coin.CodingKeys.currentHoldings)
//        let col = Coin.columTest
//        let col2 = Coin.colum(Coin.CodingKeys.currentPrice.rawValue)
//        let filterTest = (Column(Coin.CodingKeys.currentHoldings)  > 0.0) && (Column(Coin.CodingKeys.currentPrice) != 0.0)
        
//        let result = (col > 0.0) && (col2 != 0.0)
        
//        let res = filter || filter2
        
        do {
//            let holdings = try localDatabase.retrieveObjects(ofType: Coin.self,
//                                                             filter: "\(Coin.CodingKeys.currentHoldings.rawValue) > 0.0")
            
//            let holdings = try localDatabase.retrieveObjects(ofType: Coin.self,
//                                                             filter: "\(Coin.CodingKeys.currentHoldings.rawValue) > ?",
//                                                             arguments: [0.0])
//            let holdings = try localDatabase.retrieveCoins(filter: Filter(expression: Coin.currentHoldingsFilter).and(Coin.topRank))
            
//            let holdings = try localDatabase.retrieveCoins(ofType: Coin.self,
//                                                           filter: Filter(expression: Coin.currentHoldingsFilter).and(Filter._Coins.topRank2))
            
//            let holdings = try localDatabase.retrieveCoins(ofType: Coin.self,
//                                                           filter: Filter(expression: Filter._Coins.holdings).and(Filter._Coins.topRank))
            
//            let holdings = try localDatabase.retrieveCoins(ofType: Coin.self,
//                                                           filter: Coin._currentHoldingsFilter.or(Coin.topRank2))
            
//            let holdings = try localDatabase.fetchTest_2(Coin.testHoldings.and(Coin.testRank))
            let holdings = try localDatabase.fetch(type: Coin.self,
                                                   filter: Coin.currentHoldingsFilter.and(Coin.topRank))
            
//            let holdings2 = try localDatabase.retrieveObjects(ofType: Coin.self,
//                                                             filter: "\(Coin.CodingKeys.currentHoldings.rawValue) > ?",
//                                                             arguments: [0.0])
            self.holdingCoins = holdings
        } catch {
            
        }
        
//        do {
//            let holdings = try localDatabase.fetchNew(type: Coin.self,
//                                                      filters: [filter, filter2])
//            self.holdingCoins = holdings
//        } catch {
//            print("error getting coins from db: \(error)")
//        }
//        
//        let filter = Coin.filter(DBColumn("") > 2)
//        let asd =  Coin.holdColumn > 2
//        let filter = Coin.Columns.rank
//        func retrieveHoldingCoins() {
////            do {
////                let coins = try localDatabase.fetch2(Coin.self) {
////                    $0.filter(Coin.Columns.rank > 10)
////                }
////                print(coins)
////            } catch {
////                print(error)
////            }
//            
//        }
//        
//        let fl = DBFilter2.greaterThan(key: "marketCapRank", value: 10).predicate
//        
//        try? localDatabase.retrieveObjects(ofType: Coin.self, filter: fl)
//        
//        do {
//            try localDatabase.retrieveObjects(ofType: Coin.self,
//                                              filter: "marketCapRank < ?", arguments: [])
//            
//            localDatabase.retrieveObjects(ofType: Coin.self, filter: Column("age") >= 18)
//        } catch {
//            
//        }
    }
}

//struct UserRepository {
//    func fetchAdults() throws -> [User] {
////        try GRDBDatabase().retrieveObjects(
////            ofType: User.self,
////            filter: Column("age") >= 18   // ← Column comes from GRDB, but only needed where GRDB is imported
////        )
//    }
//}
