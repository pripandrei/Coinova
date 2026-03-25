//
//  SearchCoinService.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/25/26.
//

import Foundation

protocol CoinSearchable: AnyObject
{
    var searchedCoins: [Coin]? { get }
    func search(searchQuery: String, _ coins: [Coin])
    func reset()
}

@Observable
final class SearchCoinService: CoinSearchable
{
    private var searchTask: Task<Void, Never>?
    private(set) var searchedCoins: [Coin]? = nil
    
    func search(searchQuery: String, _ coins: [Coin])
    {
        searchTask?.cancel()
        
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else {return}
            
            searchCoins(query: searchQuery, in: coins)
        }
    }
    
    private func searchCoins(query: String, in coins: [Coin])
    {
        guard !query.isEmpty else
        {
            self.searchedCoins = nil
            return
        }
        
        let q = query.lowercased()
        
        self.searchedCoins = coins
            .filter { $0.id.lowercased().contains(q) || $0.symbol.lowercased().contains(q) }
            .sorted { a, b in
                let aName = a.name.lowercased()
                let bName = b.name.lowercased()
                
                let aIsPrefix = aName.hasPrefix(q)
                let bIsPrefix = bName.hasPrefix(q)
                
                if aIsPrefix != bIsPrefix
                {
                    return aIsPrefix
                }
                
                return aName < bName
            }
    }
    
    func reset() {
        searchTask?.cancel()
        searchedCoins = nil
    }
}
