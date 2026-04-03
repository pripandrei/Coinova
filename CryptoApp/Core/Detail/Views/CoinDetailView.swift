//
//  CoinDetailView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/1/26.
//

import SwiftUI

struct CoinDetailScreen: View
{
    @State private var viewModel: CoinDetailViewModel
    
    init(coin: Coin) {
        self._viewModel = State(wrappedValue: .init(coin: coin))
    }
    
    var body: some View
    {
        ZStack
        {
            Text("Welcome to coin detail view, selected coin: \(viewModel.coin.id)")
        }
        .task {
            do
            {
                try await viewModel.getCoinDetails()
            } catch {
                print("Error fetching coin details: \(error.localizedDescription)")
            }
        }
    }
}
