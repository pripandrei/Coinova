//
//  ProfileView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/21/26.
//


import SwiftUI
import Kingfisher

struct PortfolioView: View
{
    @Environment(HomeViewModel.self) var homeVM
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedCoin: Coin?
    @State private var holdingAmount: Double?
    
    var body: some View
    {
        NavigationStack
        {
            @Bindable var homeVM = homeVM
            
            VStack(alignment: .leading)
            {
                Text("Edit Portfolio")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.theme.accent)
                    .padding(.leading, 25)
                    .padding(.vertical, 20)
                
                SearchBarView(searchQuery: $homeVM.searchQuery)
                
                ScrollView(.horizontal, showsIndicators: false)
                {
                    LazyHStack(spacing: 0)
                    {
                        ForEach(homeVM.searchedCoins ?? homeVM.holdingCoins) { coin in
                            coinCell(coin)
                                .containerRelativeFrame(.horizontal,
                                                        count: 4,
                                                        spacing: 0,
                                                        alignment: .center)
                        }
                    }
                    .frame(height: 120)
                    .scrollTargetLayout()
                }
                .contentMargins(.horizontal,
                                20,
                                for: .scrollContent)
//                .contentMargins(.vertical, 20, for: .scrollContent)
//                .contentMargins(-15, for: .scrollIndicators)
                .scrollTargetBehavior(.viewAligned)
                .scrollClipDisabled()
//                .background(.blue.opacity(0.3))
                .padding(.top, 40)
                
                portfolioInputSection
                
                Spacer()
            }
            .toolbar {
                toolbarContent
            }
        }
    }
}


//MARK: View components
extension PortfolioView
{
    private func coinCell(_ coin: Coin) -> some View
    {
        VStack(spacing: 10)
        {
            KFImage(URL(string: coin.image))
                .memoryCacheExpiration(.expired)
                .cancelOnDisappear(true)
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
                .opacity(selectedCoin == coin ? 1.0 : 0.0)
                .animation(.spring(duration: 0.4), value: selectedCoin)
        }
        .onTapGesture {
            self.selectedCoin = coin
        }
    }
    
    private var portfolioInputSection: some View
    {
        VStack(spacing: 20)
        {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text("\(selectedCoin?.currentPrice.asCurrenyWithDecimals() ?? "0.00")")
            }
            
            Divider()
            
            HStack {
                Text("Amount holding: ")
                Spacer()
                TextField("Ex: 1.7",
                          value: $holdingAmount,
                          formatter: Double.amountFormatter)
                .frame(maxWidth: 150)
                .fixedSize()
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current value: ")
                Spacer()
//                Text("\(selectedCoin?.currentHoldingsValues.asCurrenyWithDecimals() ?? "0.00")")
                Text("\(getCurrentValue().asCurrenyWithDecimals())")
            }
        }
        .foregroundStyle(Color.theme.accent)
        .font(.headline)
        .fontWeight(.medium)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .onChange(of: selectedCoin) { oldValue, newValue in
            self.holdingAmount = newValue?.currentHoldings
        }
    }
    
    private func getCurrentValue() -> Double
    {
        return (selectedCoin?.currentPrice ?? 0.0) * (self.holdingAmount ?? 0.0)
    }
}

//MARK: ToolBar
extension PortfolioView
{
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent
    {
        if #available(iOS 26.0, *)
        {
            ToolbarItem(placement: .topBarLeading) {
                NavigationButton(style: .icon("xmark")) {
                    dismiss.callAsFunction()
                }
            }
            .sharedBackgroundVisibility(.hidden)
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationButton(style: .text("Save")) {
                    dismiss.callAsFunction()
                }
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            
            ToolbarItem(placement: .topBarLeading) {
                NavigationButton(style: .icon("xmark")) {
                    dismiss.callAsFunction()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationButton(style: .text("Save")) {
                    dismiss.callAsFunction()
                }
            }
        }
    }
}

#Preview {
    let vm = HomeViewModel()
    return PortfolioView()
        .environment(vm)
}
