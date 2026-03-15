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
            CoinService()
        }.singleton
    }
    
    var imageService: Factory<ImageDownloadable>
    {
        self { @MainActor in ImageLoader() }
    }
    
    var cacheService: Factory<DataCacheable>
    {
        self { @MainActor in CacheService() }
    }
}
