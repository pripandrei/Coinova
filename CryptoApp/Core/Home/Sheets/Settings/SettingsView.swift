//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/27/26.
//

import SwiftUI
import Kingfisher
import Foundation

struct SettingsView: View
{
    @AppStorage(AppAppearanceMode.key) var appAppearance: AppAppearanceMode?
    
    @Environment(\.dismiss) var dismiss
    @State private var currentTheme: AppAppearanceMode = .system
    
    init()
    {
        self._currentTheme = .init(initialValue: appAppearance ?? .system)
    }
    
    var body: some View
    {
        NavigationStack
        {
            List {
                coinGeckoSection
                appearanceSection
                aboutUsSection
            }
            .listStyle(.grouped)
//            .animation(.bouncy(duration: 1.25),
//                       value: currentTheme)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    closeButton
                }
                .hideToolbarInteractionIfNeeded()
            }
            .onChange(of: currentTheme) { _, newValue in
                appAppearance = newValue
            }
            .preferredColorScheme(currentTheme.resolvedScheme)
        }
    }
}

//MARK: List sections
extension SettingsView
{
    private var coinGeckoSection: some View
    {
        Section("Coingecko".uppercased())
        {
            VStack
            {
                Image("Coingecko_logo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 110)
                
                Text("The cryptocurrency that is used in the app comes from Coingecko API. \nPrices may be slightly delayed.")
                    .font(.headline)
                    .foregroundStyle(Color.theme.accent)
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
            }
        }
    }
    
    private var appearanceSection: some View
    {
        Section("Appearance".uppercased()) {
            HStack
            {
                Image(systemName: "moon.stars")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 20)
                    
                Text("Appearance")
                
                Spacer()
                
                appearanceMenu
            }
        }
    }
    
    private var appearanceMenu: some View
    {
        Menu {
            Picker(selection: $currentTheme)
            {
                ForEach(AppAppearanceMode.allCases) { item in
                    HStack
                    {
                        Text(item.rawValue)
                    }
                }
            } label: {
                EmptyView()
            }
        } label: {
            HStack
            {
                Text(currentTheme.rawValue.capitalized)
                Image(systemName: "chevron.up.chevron.down")
            }
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: 150, alignment: .trailing)
        }
    }

    
    private var aboutUsSection: some View
    {
        Section("About us".uppercased()) {
            ForEach(DestinationService.allCases) { item in
                HStack(spacing: 15)
                {
                    Image(systemName: item.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 20)
                    Link(item.title, destination: item.link)
                }
                .foregroundStyle(Color.theme.accent)
            }
        }
    }
}

//MARK: - view components
extension SettingsView
{
    private var closeButton: some View
    {
        NavigationButton(style: .icon("xmark")) {
            dismiss.callAsFunction()
        }
    }
}


// MARK: - Destination links
extension SettingsView
{
    enum DestinationService: Identifiable, CaseIterable
    {
        case termsOfService
        case privacyPolicy
        case website
        case learnMore
        
        var id: Self
        {
            return self
        }
        
        var icon: String
        {
            switch self
            {
            case .learnMore: return "text.magnifyingglass"
            case .privacyPolicy: return "lock.shield"
            case .termsOfService: return "text.page"
            case .website: return "link"
            }
        }
        
        var title: String
        {
            switch self
            {
            case .learnMore: return "Learn more"
            case .privacyPolicy: return "Privacy policy"
            case .termsOfService: return "Terms of service"
            case .website: return "Website"
            }
        }
        
        var link: URL!
        {
            switch self
            {
            case .learnMore: return URL(string: "https://github.com/andrei-pripa")!
            case .privacyPolicy: return URL(string: "https://github.com/andrei-pripa")!
            case .termsOfService: return URL(string: "https://github.com/andrei-pripa")!
            case .website: return URL(string: "https://github.com/andrei-pripa")!
            }
        }
    }
}

enum AppAppearanceMode: String, CaseIterable, Identifiable
{
    case dark
    case light
    case system
    
    var id: Self
    {
        return self
    }
    
    var resolvedScheme: ColorScheme?
    {
        switch self
        {
        case .dark: return .dark
        case .light: return .light
        case .system: return nil
        }
    }
}

extension AppAppearanceMode
{
    static let key = "appAppearance"
}


#Preview {
    SettingsView()
}
