//
//  Untitled.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/11/26.
//

import Foundation

@Observable
final class CoinHistoryPriceChartViewModel
{
    let coin: Coin
    let minPrice: Double
    let maxPrice: Double
    var chartData: [PricePoint] = []
    
    init(coin: Coin)
    {
        self.coin = coin
        self.minPrice = coin.sparklineIn7d?.price.min() ?? 0.0
        self.maxPrice = coin.sparklineIn7d?.price.max() ?? 0.0
        self.chartData = getChartData(from: coin)
    }
    
    var priceRangeX: ClosedRange<Date>
    {
        guard let first = chartData.first?.date,
              let last = chartData.last?.date else {
            return Date()...Date()
        }

        let padding: TimeInterval = 60 * 60 * 24 // regulate chart padding
        return first...last.addingTimeInterval(padding)
    }
    
    var priceRangeY: ClosedRange<Double>
    {
        let padding = (maxPrice - minPrice) * 0.10
        return (minPrice - padding)...(maxPrice + padding)
//        return minPrice...maxPrice
    }

    private func getChartData(from coin: Coin) -> [PricePoint]
    {
        let totalPoints = coin.sparklineIn7d?.price.count ?? 0
        let secondsIn7Days: Double = 7 * 24 * 60 * 60

        let interval = secondsIn7Days / Double(totalPoints)
        
        let now = Date()
        
        let chartData: [PricePoint] = coin.sparklineIn7d?.price
            .enumerated()
            .map { index, price in
                let timeOffset = Double(totalPoints - index) * interval
                let date = now.addingTimeInterval(-timeOffset)
                
                return PricePoint(date: date, price: price)
            } ?? []
        
        return chartData
    }
}
