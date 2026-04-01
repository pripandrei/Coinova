//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/12/26.
//

import SwiftUI
import FactoryKit

@main
struct CryptoAppApp: App
{
    @State private var navigationRouter = NavigationRouter()
    
    init() {
        #if DEBUG
        configureMockData()
        #endif
    }
    
    var body: some Scene
    {
        WindowGroup {
            HomeView()
                .environment(navigationRouter)
        }
    }
}

#if DEBUG
extension CryptoAppApp
{
    private func configureMockData()
    {
        Container.shared.coinService.register { @MainActor in
            MockCoinService()
        }
        
        Container.shared.marketDataService.register { @MainActor in
            MockMarketDataService()
        }
        
    }
}
#endif
