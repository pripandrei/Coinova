//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//


import Foundation
import Combine

@Observable
final class HomeViewModel
{
    var coins: [Coin] = []
    let service: CoinService = .init()
    
    private var subscribers: Set<AnyCancellable> = []
    
    func getCoins()
    {
        do {
            try service.fetchCoins(from: "urlsome")
        } catch {
            print("Error getting coins: \(error)")
        }
    }
    
    func setCoinsBinding()
    {
        service.$coins
            .sink { [weak self] coins in
                self?.coins = coins
            }.store(in: &subscribers)
    }
}
