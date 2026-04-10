//
//  Config.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/10/26.
//

import Foundation

enum Config
{
    static let coinGeckoAPIKey: String = {
        guard let key = Bundle.main.infoDictionary?["COINGECKO_API_KEY"] as? String, !key.isEmpty else
        {
            fatalError("CoinGecko API key not set in Info.plist")
        }
        return key
    }()
}
