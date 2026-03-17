//
//  DeveloperPreview.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//

import Foundation


#if DEBUG
class DeveloperPreview
{
    static let instance = DeveloperPreview()
    private init() {}
     
    let coin: Coin = .init(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
//        image: "https://img.freepik.com/free-vector/hand-painted-sunset-mountain-trees-landscape_1048-19076.jpg?semt=ais_hybrid&w=740&q=80",
        currentPrice: 67432.0,
        marketCap: 1_327_000_000_000,
        marketCapRank: 1,
        fullyDilutedValuation: 1_415_000_000_000,
        totalVolume: 23_500_000_000,
        high24h: 68_100.0,
        low24h: 66_800.0,
        priceChange24h: 632.0,
        priceChangePercentage24h: 0.94,
        marketCapChange24h: 12_500_000_000,
        marketCapChangePercentage24h: 0.95,
        circulatingSupply: 19_700_000,
        totalSupply: 21_000_000,
        maxSupply: 21_000_000,
        ath: 73_738.0,
        athChangePercentage: -8.54,
        athDate: "2024-03-14T07:10:36.635Z",
        atl: 67.81,
        atlChangePercentage: 99_400.5,
        atlDate: "2013-07-06T00:00:00.000Z",
        lastUpdated: "2024-11-01T12:00:00.000Z",
        sparklineIn7d: SparklineIn7d(price: [62000, 63500, 65000, 64200, 66100, 67000, 67432]),
        priceChangePercentage24hInCurrency: 0.94,
        currentHoldings: 3.5
    )
    
    func makeMockHomeViewModel() -> MockHomeViewModel
    {
        let homeViewModelMock: MockHomeViewModel = .init()
        return homeViewModelMock
    }
}
#endif

