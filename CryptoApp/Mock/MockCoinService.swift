//
//  MockCoinService.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/20/26.
//

import Combine

#if DEBUG
final class MockCoinService: CointServiceProtocol
{
    var holdingCoins: CurrentValueSubject<[Coin], Never> = .init([])
    
    var coins: CurrentValueSubject<[Coin], Never> = .init([])
    
    func fetchCoins(from url: String) throws {
        self.coins.send(Coin.mockCoins)
    }
    
    func retrieveHoldingCoins() {
        self.holdingCoins.send(Coin.mockHoldings)
    }
}
#endif
