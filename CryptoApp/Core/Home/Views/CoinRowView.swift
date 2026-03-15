//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/14/26.
//

import SwiftUI
import FactoryKit

struct CoinRowView: View
{
    let coin: Coin
    @Injected(\.imageService) var imageService
    @State private var _coinImage: Image?
    
    var body: some View
    {
        HStack
        {
            Text("\(coin.marketCapRank ?? 0)")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 5)
             
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
        .task {
            do {
                guard let imageData = try await imageService.loadImage(from: coin.image),
                      let image = UIImage(data: imageData) else {return}
                self._coinImage = Image(uiImage: image)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @ViewBuilder
    private var coinImage: some View
    {
        if let image = _coinImage
        {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(.circle)
        } else {
            ProgressView()
                .frame(width: 40, height: 40)
        }
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



