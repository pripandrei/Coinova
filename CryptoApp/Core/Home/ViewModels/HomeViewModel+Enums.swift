//
//  HomeViewModel+Enums.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/19/26.
//


enum CoinSortOption
{
    case minRank
    case maxRank
    case minPrice
    case maxPrice
    case minHoldings
    case maxHoldings
    
    mutating func toggle(_ option: Self)
    {
        if option == self
        {
            self = reversed
        } else {
            self = option
        }
    }
    
    var reversed: Self {
        switch self {
        case .minRank: return .maxRank
        case .maxRank: return .minRank
        case .minPrice: return .maxPrice
        case .maxPrice: return .minPrice
        case .minHoldings: return .maxHoldings
        case .maxHoldings: return .minHoldings
        }
    }
}

enum HomeDisplayMode
{
    case livePrices
    case portfolio
    
    var title: String
    {
        switch self
        {
        case .livePrices: return "Live Prices"
        case .portfolio: return "Portfolio"
        }
    }
}
