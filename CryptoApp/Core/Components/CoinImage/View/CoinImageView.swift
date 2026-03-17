//
//  CoinImageView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/15/26.
//

import SwiftUI

struct CoinImage: View
{
    @State private var viewModel: CoinImageViewModel
    
    init(coin: Coin)
    {
        self._viewModel = State(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View
    {
        Group {
            if let image = viewModel.coinImage
            {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(.circle)
            } else {
                ProgressView()
                    .frame(width: 40, height: 40)
            }
        }
        .task {
            await viewModel.loadCoinImage()
        }
    }
}
