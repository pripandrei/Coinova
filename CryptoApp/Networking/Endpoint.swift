//
//  Endpoint.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/17/26.
//

import Foundation

enum APIEndpoint
{
    static let baseURL = "https://api.coingecko.com/api/v3"
    
    case coins
    case marketData
    
    var path: String
    {
        switch self
        {
        case .coins: return "/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        case .marketData: return "/global"
        }
    }
    
    var url: String
    {
        return "\(Self.baseURL)\(path)"
    }
}
