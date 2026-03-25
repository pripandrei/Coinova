//
//  Coin.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/12/26.
//

// API : https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h



// JSON DATA:
//{
//    "id": "bitcoin",
//    "symbol": "btc",
//    "name": "Bitcoin",
//    "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
//    "current_price": 70599,
//    "market_cap": 1411261512921,
//    "market_cap_rank": 1,
//    "fully_diluted_valuation": 1411261512921,
//    "total_volume": 35787731553,
//    "high_24h": 72105,
//    "low_24h": 70417,
//    "price_change_24h": -1431.18993402796,
//    "price_change_percentage_24h": -1.98693,
//    "market_cap_change_24h": -32942885830.178,
//    "market_cap_change_percentage_24h": -2.28104,
//    "circulating_supply": 20002003,
//    "total_supply": 20002003,
//    "max_supply": 21000000,
//    "ath": 126080,
//    "ath_change_percentage": -44.00461,
//    "ath_date": "2025-10-06T18:57:42.558Z",
//    "atl": 67.81,
//    "atl_change_percentage": 104014.38172,
//    "atl_date": "2013-07-06T00:00:00.000Z",
//    "roi": null,
//    "last_updated": "2026-03-14T15:54:52.900Z",
//    "sparkline_in_7d": {
//      "price": [67991.1035699002, 67916.103289176, 68019.1601918745, 67899.1508484934, 67801.0163226986 ...]
//    },
//    "price_change_percentage_24h_in_currency": -1.98693284435742
//  }

import Foundation
import GRDB

struct Coin: Identifiable, Codable, FetchableRecord, PersistableRecord
{
    static let databaseTableName: String = "coin"
    
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double?
    let marketCapRank: Int?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24h: Double?
    let low24h: Double?
    let priceChange24h: Double?
    let priceChangePercentage24h: Double?
    let marketCapChange24h: Double?
    let marketCapChangePercentage24h: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
    let ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl: Double?
    let atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let priceChangePercentage24hInCurrency: Double?
    let currentHoldings: Double?
    let sparklineIn7d: SparklineIn7d?

    enum CodingKeys: String, CodingKey
    {
        case id, symbol, name, image
        case currentPrice                       = "current_price"
        case marketCap                          = "market_cap"
        case marketCapRank                      = "market_cap_rank"
        case fullyDilutedValuation              = "fully_diluted_valuation"
        case totalVolume                        = "total_volume"
        case high24h                            = "high_24h"
        case low24h                             = "low_24h"
        case priceChange24h                     = "price_change_24h"
        case priceChangePercentage24h           = "price_change_percentage_24h"
        case marketCapChange24h                 = "market_cap_change_24h"
        case marketCapChangePercentage24h       = "market_cap_change_percentage_24h"
        case circulatingSupply                  = "circulating_supply"
        case totalSupply                        = "total_supply"
        case maxSupply                          = "max_supply"
        case ath
        case athChangePercentage                = "ath_change_percentage"
        case athDate                            = "ath_date"
        case atl
        case atlChangePercentage                = "atl_change_percentage"
        case atlDate                            = "atl_date"
        case lastUpdated                        = "last_updated"
        case sparklineIn7d                      = "sparkline_in_7d"
        case priceChangePercentage24hInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings                    = "current_holdings"
    }
    
    var currentHoldingsValues: Double
    {
        return (self.currentHoldings ?? 0.0) * currentPrice
    }
}

struct SparklineIn7d: Codable
{
    let price: [Double]
}

extension Coin: Equatable
{
    static func == (lhs: Coin, rhs: Coin) -> Bool
    {
        lhs.id == rhs.id && lhs.currentHoldings == rhs.currentHoldings
    }
}

//MARK: - update holdings
extension Coin
{
    func updateHoldings(_ value: Double) -> Coin
    {
        return Coin(
            id: id,
            symbol: symbol,
            name: name,
            image: image,
            currentPrice: currentPrice,
            marketCap: marketCap,
            marketCapRank: marketCapRank,
            fullyDilutedValuation: fullyDilutedValuation,
            totalVolume: totalVolume,
            high24h: high24h,
            low24h: low24h,
            priceChange24h: priceChange24h,
            priceChangePercentage24h: priceChangePercentage24h,
            marketCapChange24h: marketCapChange24h,
            marketCapChangePercentage24h: marketCapChangePercentage24h,
            circulatingSupply: circulatingSupply,
            totalSupply: totalSupply,
            maxSupply: maxSupply,
            ath: ath,
            athChangePercentage: athChangePercentage,
            athDate: athDate,
            atl: atl,
            atlChangePercentage: atlChangePercentage,
            atlDate: atlDate,
            lastUpdated: lastUpdated,
            priceChangePercentage24hInCurrency: priceChangePercentage24hInCurrency,
            currentHoldings: (currentHoldings ?? 0.0) + value,
            sparklineIn7d: sparklineIn7d
        )
    }
}
