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
    @State private var sheetOption: HomeSheetOption?
    
    @Environment(NavigationRouter.self) private var router
    
    var body: some View
    {
        @Bindable var router = router
        
        NavigationStack(path: $router.homePath)
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
                        .loadingIndicator(viewModel.marketStatistics.isEmpty, size: 30)
                    
                    SearchBarView(searchQuery: $viewModel.searchQuery)
                        .padding(.vertical, 20)
                    
                    coinListHeader
                    
                    ZStack
                    {
                        contentList
                            .loadingIndicator(viewModel.areCoinsLoading)
                        
                        if shouldShowNoCoinDataView
                        {
                            noCoinDataView
                        }
                    }
                }
            }
            .task {
                if viewModel.subscribers.isEmpty
                {
                    viewModel.setupSubscribers()
                    viewModel.retrieveHoldingCoins()
                    await viewModel.getCoins()
                }
            }
            .environment(viewModel)
            .navigationDestination(for: HomeRoute.self) { route in
                switch route
                {
                case .coinDetails(let coin): CoinDetailScreen(coin: coin)
                }
            }
        }
    }
}

//MARK: - View components
extension HomeView
{
    private var header: some View
    {
        HStack
        {
            NavigationButton(style: viewModel.displayMode == .livePrices ? .icon("info") : .icon("plus"))
            {
                sheetOption = viewModel.displayMode == .livePrices ? .settings : .portfolio
                Task { viewModel.resetSearch() }
            }
            .background(
                InfoButtonAnimation(animationInitiated: shouldAnimateInfoButton())
            )
            .sheet(item: $sheetOption) { item in
                switch item {
                case .portfolio: PortfolioView(viewModel.coins)
                case .settings: Text("implement settings")
                }
            }
            
            Spacer()
            
            Text(viewModel.displayMode.title)
                .font(.title3)
                .fontWeight(.semibold)
                .animation(nil)
            
            Spacer()
            
            NavigationButton(style: .icon("chevron.right"))
            {
                withAnimation(.bouncy(duration: 0.5))
                {
                    self.viewModel.displayMode = viewModel.displayMode == .livePrices ? .portfolio : .livePrices
                }
            }
            .rotationEffect(.degrees(viewModel.displayMode == .livePrices ? 0 : 180))
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
            CoinListView(coins: viewModel.searchService.searchedCoins ?? viewModel.coins)
                .transition(.move(edge: .leading))
        case .portfolio:
            CoinListView(coins: viewModel.searchService.searchedCoins ?? viewModel.holdingCoins)
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
    
    private var shouldShowNoCoinDataView: Bool
    {
        return viewModel.searchService.searchedCoins?.isEmpty == true || (viewModel.holdingCoins.isEmpty && viewModel.displayMode == .portfolio)
    }
}

//MARK: - Sheet enum
extension HomeView
{
    enum HomeSheetOption: Identifiable
    {
        case portfolio
        case settings
        
        var id: Self { self }
    }
}


#Preview {
    HomeView()
        .environment(NavigationRouter())
}

