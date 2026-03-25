//
//  PortfolioCoinCellView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/25/26.
//

import SwiftUI
import Kingfisher

struct PortfolioCoinCellView: View
{
    let coin: Coin
    let isSelected: Bool
    
    var body: some View
    {
        VStack(spacing: 10)
        {
            KFImage(URL(string: coin.image))
                .memoryCacheExpiration(.expired)
                .cancelOnDisappear(true)
                .placeholder({
                    ProgressView()
                        .frame(width: 30, height: 30)
                })
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
            
            VStack(spacing: 2)
            {
                Text(coin.symbol)
                    .font(.headline)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.theme.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                
                Text(coin.name.capitalized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .frame(maxWidth: 90)
            .frame(maxHeight: 50)
        }
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(.green,
                              style: StrokeStyle(lineWidth: 2.0))
                .opacity(isSelected ? 1.0 : 0.0)
                .animation(.spring(duration: 0.4), value: isSelected)
        }
    }
}
