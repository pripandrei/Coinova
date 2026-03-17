//
//  ContentView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/12/26.
//

import SwiftUI

struct HomeView: View
{
    @State private var currentNavigationStatus: NavigationStatus = .livePrices
    @State private var viewModel: HomeViewModel = .init()
    
    var body: some View
    {
        ZStack
        {
            Color.theme.background
                .ignoresSafeArea()
         
            VStack
            {
                header
                coinsList
//                Spacer()
            }
        } 
        .onAppear {
            viewModel.setupBindings()
            viewModel.getCoins()
        }
        .environment(viewModel)
    }
}

//MARK: - View components
extension HomeView
{
    private var header: some View
    {
        HStack
        {
            NavigationButton(iconName: currentNavigationStatus == .livePrices ? "info" : "plus")
                .background(
                    InfoButtonAnimation(animationInitiated: shouldAnimateInfoButton())
                )
                .onTapGesture {
                    
                }
            
            Spacer()
            
            Text(currentNavigationStatus.title)
                .font(.title3)
                .fontWeight(.semibold)
                .animation(nil)
            
            Spacer()
            
            NavigationButton(iconName: "chevron.right")
                .rotationEffect(.degrees(currentNavigationStatus == .livePrices ? 0 : 180))
                .onTapGesture
            {
                withAnimation(.linear(duration: 0.3))
                {
                    self.currentNavigationStatus = currentNavigationStatus == .livePrices ? .portfolio : .livePrices
                }
            }
           
        }
        .padding(.horizontal, 30)
    }
    
    private var coinsList: some View
    {
        List(viewModel.coins) { coin in 
            CoinRowView(coin: coin)
//                        .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .listStyle(.plain)
    }
}

//MARK: - Execute functions
extension HomeView
{
    private func shouldAnimateInfoButton() -> Bool
    {
        return currentNavigationStatus == .livePrices ? false : true
    }
}

extension HomeView
{
    enum NavigationStatus
    {
        case livePrices
        case portfolio
        
        var title: String
        {
            switch self
            {
            case .livePrices: return "Live Prices"
            case .portfolio: return "Portfolio"
            }
        }
    }
}

#Preview {
    HomeView()
//    NavigationButton(iconName: "info")
}

