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
    
    var maxPricePoint: PricePoint?
    {
        return chartData.max(by: { $0.price < $1.price })
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
        guard let prices = coin.sparklineIn7d?.price,
              !prices.isEmpty else { return [] }

        let total = prices.count
        let now = Date.now
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: now)!
        let totalInterval = now.timeIntervalSince(sevenDaysAgo)

        return prices.indices.map { i in
            
            let fraction = Double(i) / Double(total - 1)
            let date = sevenDaysAgo.addingTimeInterval(fraction * totalInterval)
            return PricePoint(date: date, price: prices[i])
        }
    }
}
