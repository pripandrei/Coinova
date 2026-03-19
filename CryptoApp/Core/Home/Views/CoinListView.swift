//
//  CoinListView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/19/26.
//

import SwiftUI

struct CoinListView: View
{
    let coins: [Coin]
    
    var body: some View
    {
        List(coins) { coin in
            CoinRowView(coin: coin)
                .listRowInsets(EdgeInsets(top: 10,
                                         leading: 5,
                                         bottom: 10,
                                         trailing: 15))
        }
        .listStyle(.plain)
        .animation(.easeOut, value: coins)
    }
}
