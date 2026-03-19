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
                
                coinListHeader
                
                ZStack
                {
                    contentList
                    if viewModel.searchedCoins?.isEmpty == true
                    {
                        noCoinDataView
                    }
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
 
    private var coinListHeader: some View
    {
        HStack
        {
            HStack(spacing: 5)
            {
                let opacity = (viewModel.coinSortOption == .maxRank || viewModel.coinSortOption == .minRank) ? 1.0 : 0.0
                Text("coins")
                Image(systemName: "chevron.up")
                    .opacity(opacity)
                    .rotationEffect(.degrees(viewModel.coinSortOption == .minRank ? 0 : 180))
                    .animation(.linear, value: viewModel.coinSortOption)
            }
            .onTapGesture {
                viewModel.coinSortOption.toggle(.maxRank)
            }
            
            Spacer()
            
            HStack(spacing: 5)
            {
                let opacity = (viewModel.coinSortOption == .maxHoldings || viewModel.coinSortOption == .minHoldings) ? 1.0 : 0.0
                Text("holdings")
                    .animation(.linear, value: viewModel.displayMode)
                Image(systemName: "chevron.up")
                    .opacity(opacity)
                    .rotationEffect(.degrees(viewModel.coinSortOption == .minHoldings ? 0 : 180))
                    .animation(.linear, value: viewModel.coinSortOption)
            }
            .opacity(viewModel.displayMode == .portfolio ? 1 : 0)
            .onTapGesture {
                viewModel.coinSortOption.toggle(.maxHoldings)
            }
            
            
            HStack(spacing: 5)
            {
                let opacity = (viewModel.coinSortOption == .minPrice || viewModel.coinSortOption == .maxPrice) ? 1.0 : 0.0
                Text("price")
                    .frame(maxWidth: .infinity,
                           alignment: .trailing)
                    .containerRelativeFrame(.horizontal) { width, _ in
                        width / 5.0
                    }
                Image(systemName: "chevron.up")
                    .opacity(opacity)
                    .rotationEffect(.degrees(viewModel.coinSortOption == .maxPrice ? 0 : 180))
                    .animation(.linear, value: viewModel.coinSortOption)
            }
            .onTapGesture {
                viewModel.coinSortOption.toggle(.maxPrice)
            }
//            .background(.blue)
        }
        .font(.callout)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var contentList: some View
    {
        switch viewModel.displayMode
        {
        case .livePrices:
            CoinListView(coins: viewModel.searchedCoins ?? viewModel.coins)
                .transition(.move(edge: .leading))
        case .portfolio:
            CoinListView(coins: viewModel.searchedCoins ?? viewModel.holdingCoins)
                .transition(.move(edge: .trailing))
        }
    }
    
    private var noCoinDataView: some View
    {
        VStack {
            Image(systemName: "text.page.badge.magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .fontWeight(.light)
            
            Text("No coins found")
                .font(.headline)
        }
        .foregroundStyle(Color.theme.secondaryText)
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

