//
//  StatisticsModel.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/17/26.
//

import Foundation

struct StatisticModel: Identifiable
{
    let id: UUID = UUID()
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil)
    {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}

extension StatisticModel
{
    enum Title: String
    {
        case marketCap = "Market Cap"
        case dayVolume = "24h Volume"
        case BTCDominance = "BTC Dominance"
        case portfolio = "Portfolio"
    }
}
