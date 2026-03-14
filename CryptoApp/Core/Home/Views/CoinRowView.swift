//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//

import SwiftUI

struct CoinRowView: View
{
    let coin: Coin
    
    var body: some View
    {
        HStack
        {
            Text("\(coin.marketCapRank ?? 0)")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 5)
            
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
//                .background(.blue)
                .clipShape(.circle)
            Text(coin.symbol.uppercased())
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            currentPrice
        }
    }
    
    private var currentPrice: some View
    {
        VStack(alignment: .trailing)
        {
            Text("\(coin.currentPrice)")
            Text("\(coin.priceChangePercentage24h ?? 0.0)%")
                .foregroundStyle(Color.theme.green)
        }
        .font(.headline)
    }
    
    private var holdings: some View
    {
        VStack(alignment: .trailing)
        {
//            Text("\(coin.currentPrice)")
//            Text("\(coin.priceChangePercentage24h ?? 0.0)%")
//                .foregroundStyle(Color.theme.green)
        }
        .font(.headline)
    }
}

#Preview {
    let coins = DeveloperPreview.instance.coin
    CoinRowView(coin: coins)
}



