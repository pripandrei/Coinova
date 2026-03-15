//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//

import SwiftUI
import FactoryKit
import Kingfisher

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
             
//            CoinImage(coin: coin)
            coinImage

            Text(coin.symbol.uppercased())
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            if !coin.currentHoldingsValues.isZero
            {
                holdings                
            }
            currentPrice
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var coinImage: some View
    {
        KFImage(URL(string: coin.image))
            .memoryCacheExpiration(.expired) // don't store in memory cache, only Disk cache
            .cancelOnDisappear(true)
            .placeholder({
                ProgressView()
                    .frame(width: 40, height: 40)
            })
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(.circle)
        
    }

    private var currentPrice: some View
    {
        VStack(alignment: .trailing)
        {
            Text("\(coin.currentPrice.asCurrenyWithDecimals())")
            Text("\(coin.priceChangePercentage24h?.asCurrenyWithDecimals() ?? "0.00")%")
                .foregroundStyle(Color.theme.green)
        }
        .font(.headline)
    }
    
    private var holdings: some View
    {
        VStack(alignment: .center)
        {
            Text("\(coin.currentHoldingsValues.asCurrenyWithDecimals())%")
            Text("\(coin.currentHoldings?.asCurrenyWithDecimals() ?? "0.00")")
                .foregroundStyle(Color.theme.accent)
        }
        .padding(.trailing, 10)
        .font(.headline)
    }
}
  
#Preview {
    let coins = DeveloperPreview.instance.coin
    CoinRowView(coin: coins)
}



