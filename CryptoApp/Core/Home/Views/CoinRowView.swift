//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//

import SwiftUI
import Kingfisher


struct CoinRowView: View
{
    @Environment(\.displayScale) var displayScale
    let coin: Coin
    @State private var screenWidth: CGFloat = 0.0
    
    var body: some View
    {
        ZStack
        {
//            Color.clear
//                .onGeometryChange(for: CGFloat.self) { proxy in
//                    proxy.size.width
//                } action: { newValue in
//                    self.screenWidth = newValue
//                }
//            
            HStack
            {
                marketRank
                //            CoinImage(coin: coin)
                KFCoinImage(imagePath: coin.image)
                symbol
                
                Spacer()
                
                if !coin.currentHoldingsValues.isZero
                {
                    holdings
                }
                currentPrice
                    .containerRelativeFrame(.horizontal, alignment: .trailing) { width, _ in
                        width / 3.5
                        // See FootNote.swift - [1]
                    }
            }
            .foregroundStyle(Color.theme.accent)
        }
    }
}

// MARK: - View components
extension CoinRowView
{
    private var marketRank: some View
    {
        Text("\(coin.marketCapRank ?? 0)")
            .font(.headline)
            .fontWeight(.semibold)
            .frame(width: 35)
            .foregroundStyle(Color.theme.secondaryText)
    }
    
    private var symbol: some View
    {
        Text(coin.symbol.uppercased())
            .font(.headline)
            .fontWeight(.semibold)
    }
    
    private var holdings: some View
    {
        VStack(alignment: .center)
        {
            Text("\(coin.currentHoldingsValues.asCurrencyWithDecimals())")
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text("\(coin.currentHoldings?.asDecimals() ?? "0.00")")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var currentPrice: some View
    {
        VStack(alignment: .trailing)
        {
            Text("\(coin.currentPrice.asCurrencyWithDecimals())")
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text("\(coin.priceChangePercentage24h?.asDecimals() ?? "0.00")%")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.theme.green)
        }
    }
}
  
#Preview {
    let coins = DeveloperPreview.instance.coin
    CoinRowView(coin: coins)
}



