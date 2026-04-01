//
//  CoinDetailViewModel.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/1/26.
//

import Foundation

@Observable
final class CoinDetailViewModel
{
    let coin: Coin
    
    init(coin: Coin)
    {
        self.coin = coin
    }
}
