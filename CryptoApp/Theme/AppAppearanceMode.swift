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
    
    static let key = "appAppearance"
}
