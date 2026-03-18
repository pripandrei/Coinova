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

extension StatisticModel
{
    static let mockStatistics: [StatisticModel] = [
        .init(title: StatisticModel.Title.marketCap.rawValue,
              value: 6_623_640_000.32323.abbreviated(),
              percentageChange: 12.3),
        .init(title: StatisticModel.Title.dayVolume.rawValue,
              value: 3_640_000.47.abbreviated()),
        .init(title: StatisticModel.Title.BTCDominance.rawValue,
              value: 54.34554.asPercentWithDecimals()),
        .init(title: StatisticModel.Title.portfolio.rawValue,
              value: 834.3434.abbreviated(),
              percentageChange: -3.0)
    ]
}
