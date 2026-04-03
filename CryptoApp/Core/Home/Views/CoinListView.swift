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
    @Environment(NavigationRouter.self) var router
    
    var body: some View
    {
        List(coins) { coin in
            CoinRowView(coin: coin)
                .contentShape(Rectangle())
                .listRowInsets(EdgeInsets(top: 10,
                                         leading: 5,
                                         bottom: 10,
                                         trailing: 15))
                .onTapGesture {
                    router.openCoinDetailsScreen(coin)
                }
        }
        .listStyle(.plain)
        .animation(.easeOut, value: coins)
    }
}
