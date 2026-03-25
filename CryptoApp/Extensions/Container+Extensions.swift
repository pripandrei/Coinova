//
//  Factory+Extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//

import FactoryKit

extension Container
{
    var coinService: Factory<CointServiceProtocol>
    {
        Factory(self) { @MainActor in
//            MainActor.assumeIsolated { ABC() }
            return CoinService()
        }.shared
    }
    
    var imageService: Factory<ImageDownloadable>
    {
        self { @MainActor in ImageLoader() }.shared
    }
    
    var cacheService: Factory<DataCacheable>
    {
        self { @MainActor in CacheService() }.cached
    }
    
    var marketDataService: Factory<MarketDataServiceProtocol>
    {
        self { @MainActor in
            MarketDataService()
        }.shared
    }
    
    var localDatabase: Factory<GRDBDatabase>
    {
        self { @MainActor in
            do {
                return try GRDBDatabase()
            } catch {
                fatalError("Failed to initialize database: \(error)")
            }
        }.cached
    }
    
    var searchCoinService: Factory<CoinSearchable>
    {
        self { @MainActor in
            SearchCoinService()
        }.shared
    }
}
