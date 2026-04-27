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
    @AppStorage(AppAppearanceMode.key) var appAppearance: AppAppearanceMode = .system
    
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
                .onAppear {
                    appAppearance.applyAppearance(appAppearance)
                }
                .onChange(of: appAppearance) { _, newValue in
                    appAppearance.applyAppearance(newValue)
                }
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
