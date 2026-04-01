//
//  CoinDetailViewModel.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/1/26.
//

import Foundation
import FactoryKit

@Observable
final class CoinDetailViewModel
{
    let coin: Coin
    private(set) var coinDetails: CoinDetail?
    
    @ObservationIgnored
    @Injected(\.coinService) var coinService
    
    init(coin: Coin)
    {
        self.coin = coin
    }
    
    func getCoinDetails() async throws
    {
        guard coinDetails == nil else {return}
        
        let path = APIEndpoint.coinDetails(id: self.coin.id).url
        self.coinDetails = try await coinService.fetchCoinDetails(from: path)
    }
}
