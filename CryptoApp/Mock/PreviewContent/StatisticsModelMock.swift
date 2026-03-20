//
//  StatisticsModelMock.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/20/26.
//


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
