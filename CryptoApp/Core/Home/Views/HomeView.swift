//
//  ContentView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/12/26.
//

import SwiftUI

struct HomeView: View
{
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
                HomeStatsView(showPortfolio: viewModel.displayMode == .portfolio)
                    .padding(.top, 10)
                
                SearchBarView(searchQuery: $viewModel.searchQuery)
                    .padding(.vertical, 20)
                
                switch viewModel.displayMode
                {
                case .livePrices:
                    coinsList
                        .transition(.move(edge: .leading))
                case .portfolio:
                    portfolioList
                        .transition(.move(edge: .trailing))
                }
            }
        } 
        .onAppear {
//            viewModel.setupSubscribers() // TODO: move subscribers to VM after navigation implementation
//            viewModel.getCoins()
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
            NavigationButton(iconName: viewModel.displayMode == .livePrices ? "info" : "plus")
                .background(
                    InfoButtonAnimation(animationInitiated: shouldAnimateInfoButton())
                )
                .onTapGesture {
                    
                }
            
            Spacer()
            
            Text(viewModel.displayMode.title)
                .font(.title3)
                .fontWeight(.semibold)
                .animation(nil)
            
            Spacer()
            
            NavigationButton(iconName: "chevron.right")
                .rotationEffect(.degrees(viewModel.displayMode == .livePrices ? 0 : 180))
                .onTapGesture
            {
                withAnimation(.bouncy(duration: 0.5))
                {
                    self.viewModel.displayMode = viewModel.displayMode == .livePrices ? .portfolio : .livePrices
                }
            }
           
        }
        .padding(.horizontal, 30)
    }
    
    private var coinsList: some View
    {
        let coins = viewModel.searchedCoins ?? viewModel.coins
        
        return List(coins) { coin in
            CoinRowView(coin: coin)
                        .listRowInsets(EdgeInsets(top: 10,
                                                  leading: 5,
                                                  bottom: 10,
                                                  trailing: 15))
        }
        .listStyle(.plain)
        .animation(.easeOut, value: viewModel.searchedCoins)
    }
    
    private var portfolioList: some View
    {
        let coins = viewModel.searchedCoins ?? viewModel.holdingCoins
        
        return List(coins) { coin in
            CoinRowView(coin: coin)
                .listRowInsets(EdgeInsets(top: 10,
                                          leading: 5,
                                          bottom: 10,
                                          trailing: 15))
        }
        .listStyle(.plain)
        .animation(.easeOut, value: viewModel.searchedCoins)
    }
}

//MARK: - Execute functions
extension HomeView
{
    private func shouldAnimateInfoButton() -> Bool
    {
        return viewModel.displayMode == .livePrices ? false : true
    }
}

#Preview {
    HomeView()
//    NavigationButton(iconName: "info")
}

