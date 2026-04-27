//
//  AppAppearanceMode.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/27/26.
//

import SwiftUI

enum AppAppearanceMode: String, CaseIterable, Identifiable {
    case dark = "dark"
    case light = "light"
    case system = "system"
    
    var id: Self { self }
    
    var resolvedScheme: ColorScheme? {
        switch self {
        case .dark: return .dark
        case .light: return .light
        case .system: return nil  // nil = follow device
        }
    }
}

extension AppAppearanceMode
{
    static let key = "appAppearance"
    
    func applyAppearance(_ mode: AppAppearanceMode)
    {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }
        
        switch mode
        {
        case .dark:   window.overrideUserInterfaceStyle = .dark
        case .light:  window.overrideUserInterfaceStyle = .light
        case .system: window.overrideUserInterfaceStyle = .unspecified
        }
    }
}
