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
//                .preferredColorScheme(appAppearance.resolvedScheme)
                .onAppear {
                    applyAppearance(appAppearance)
                }
                .onChange(of: appAppearance) { _, newValue in
                    applyAppearance(newValue)
                }
        }
    }
}

func applyAppearance(_ mode: AppAppearanceMode) {
    guard let window = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .flatMap({ $0.windows })
        .first(where: { $0.isKeyWindow }) else { return }
    
    switch mode {
    case .dark:   window.overrideUserInterfaceStyle = .dark
    case .light:  window.overrideUserInterfaceStyle = .light
    case .system: window.overrideUserInterfaceStyle = .unspecified  // ← key fix
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
