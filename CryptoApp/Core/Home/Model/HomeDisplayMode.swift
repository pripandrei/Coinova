//
//  HomeDisplayMode.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/19/26.
//


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
