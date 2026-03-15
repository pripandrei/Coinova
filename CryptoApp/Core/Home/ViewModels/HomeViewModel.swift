//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//


import Foundation
import Combine
import FactoryKit

@Observable
final class HomeViewModel
{
    private(set) var coins: [Coin] = []
    
    @ObservationIgnored
    @Injected(\.coinService) private var coinService
    
    private var subscribers: Set<AnyCancellable> = []
    
    func getCoins()
    {
        do {
            try coinService.fetchCoins(from: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        } catch {
            print("Error getting coins: \(error)")
        }
    }
    
    func setCoinsBinding()
    {
//        withObservationTracking {
//            let _ = coinService.coins
//        } onChange: { [weak self] in
//            guard let self else {return}
//            Task { @MainActor in
//                self.coins = self.coinService.coins
//                self.setCoinsBinding()
//            }
//        }

        coinService.coins
            .filter { !$0.isEmpty }
            .sink { [weak self] coins in
//                self?.coins = Array(coins.prefix(10))
                self?.coins = coins
//                print("Successfully fetched coins: \(coins.first!)")
                print("Successfully fetched coins: \(coins.first!.id)")
//                coins.forEach { coin in
//                    print("======== New coin: \(coin) \n")
//                }
            }.store(in: &subscribers)
    }
}



