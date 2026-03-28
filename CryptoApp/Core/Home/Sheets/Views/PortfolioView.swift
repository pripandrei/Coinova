//
//  ProfileView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/21/26.
//


import SwiftUI

struct PortfolioView: View
{
    @State private var viewModel: PortfolioViewModel
    @State private var scrollProxy: ScrollViewProxy?
    
    @FocusState private var isHoldingAmountFocused: Bool
    @FocusState private var isSearchFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    
    init(_ coins: [Coin])
    {
        self._viewModel = State(wrappedValue: PortfolioViewModel(coins: coins))
    }
    
    var body: some View
    {
        NavigationStack
        {
            ScrollViewReader { proxy in
                ScrollView
                {
                    VStack(alignment: .leading)
                    {
                        searchBar
                        
                        coinsScrollList
                        
                        if viewModel.selectedCoin != nil
                        {
                            portfolioInputSection
                                .padding(.top, 10)
                        }
                        
                        Spacer()
                    }
                    .navigationTitle("Edit Portfolio")
                    .toolbar {
                        toolbarContent
                    }
                }
                .scrollDisabled(true)
                .onAppear {
                    self.scrollProxy = proxy
                }
                .task {
                    guard viewModel.holdingCoins.isEmpty else {return}
                    viewModel.retrieveHoldingCoins()
                }
                .onChange(of: viewModel.selectedCoin) { _, newValue in
                    self.viewModel.updateHoldingAmount(newValue?.currentHoldings)
                }
            }
        }
    }
}


//MARK: View components
extension PortfolioView
{
    // search bar
    private var searchBar: some View
    {
        SearchBarView(searchQuery: $viewModel.searchQuery)
            .padding(.top, 25)
            .onChange(of: viewModel.searchQuery) { _, newValue in
                if let selectedCoin = viewModel.selectedCoin, newValue.isEmpty, !viewModel.holdingCoins.contains(selectedCoin)
                {
                    viewModel.updateSelectedCoin(nil)
                }
            }
            .focused($isSearchFocused)
            .onChange(of: isSearchFocused, { _, newValue in
                if newValue
                {
                    scrollToView()
                }
            })
    }
    
    // coin scroll list
    private var coinsScrollList: some View
    {
        ScrollView(.horizontal, showsIndicators: false)
        {
            LazyHStack(spacing: 0)
            {
                ForEach(viewModel.mergedCoins) { coin in
                    PortfolioCoinCellView(coin: coin,
                                          isSelected: viewModel.selectedCoin?.id == coin.id)
                    .onTapGesture {
                        self.selectCoin(coin)
                    }
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
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
        .padding(.top, 25)

    }

    // portfolio section
    private var portfolioInputSection: some View
    {
        VStack(spacing: 20)
        {
            HStack {
                Text("Current price of \(viewModel.selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text("\(viewModel.selectedCoin?.currentPrice.asCurrenyWithDecimals() ?? "0.00")")
            }
            
            Divider()
            
            HStack {
                Text("Amount holding: ")
                Spacer()
                TextField("Ex: 1.7",
                          value: $viewModel.selectedCoinHoldingsAbsoluteValue,
                          formatter: Double.amountFormatter)
                .frame(maxWidth: 150)
                .fixedSize()
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .focused($isHoldingAmountFocused)
                .onChange(of: isHoldingAmountFocused) { _, isFocused in
                    if isFocused
                    {
                        self.scrollToView()
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Current value: ")
                Spacer()
                Text("\(viewModel.getCurrentHoldingsValue().asCurrenyWithDecimals())")
            }
            
            Text("Invisible placeholder for scroll on keyboard up")
                .opacity(0)
                .id(Self.itemVisibilityID)
        }
        .foregroundStyle(Color.theme.accent)
        .font(.headline)
        .fontWeight(.medium)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

//MARK: - ToolBar
extension PortfolioView
{
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent
    {
        if #available(iOS 26.0, *)
        {
            ToolbarItem(placement: .topBarLeading) {
                NavigationButton(style: .icon("xmark")) {
                    onClose()
                }
            }
            .sharedBackgroundVisibility(.hidden)
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationButton(style: .text("Save"))
                {
                    onSave()
                }
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            
            ToolbarItem(placement: .topBarLeading) {
                NavigationButton(style: .icon("xmark")) {
                    onClose()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationButton(style: .text("Save")) {
                    onSave()
                }
            }
        }
    }
    
    private func onClose()
    {
        viewModel.resetSearch()
        Task // task is used just for delay purposes
        {
            try await Task.sleep(for: .milliseconds(100))
            UIApplication.shared.endEditing()
            dismiss.callAsFunction()
        }
    }
    
    private func onSave()
    {
        viewModel.saveHoldings()
        viewModel.updateSelectedCoin(nil)
        viewModel.searchQuery = ""
        UIApplication.shared.endEditing()
    }
}


// MARK: - Helpers
extension PortfolioView
{
    static let itemVisibilityID: String = "visibleOnKeyboardUp"
    
    private func scrollToView()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
        {
            withAnimation(.spring(duration: 0.4, bounce: 0.3, blendDuration: 0.9))
            {
                self.scrollProxy?.scrollTo(Self.itemVisibilityID,
                                           anchor: .bottom)
            }
        }
    }
    
    private func selectCoin(_ coin: Coin)
    {
        viewModel.updateSelectedCoin(coin)
        scrollToView()
    }
    
    private var showPortfolioInputSection: Bool
    {
        guard let selectedCoin = viewModel.selectedCoin else { return false }
        
        let isHolding = viewModel.holdingCoins.contains(selectedCoin)
        let hasResults = viewModel.searchService.searchedCoins?.isEmpty == false
        let hasQuery = !viewModel.searchQuery.isEmpty
        
        if isHolding {
            return !hasQuery || hasResults
        } else {
            return hasQuery && hasResults
        }
    }
}

#Preview {
    let vm = HomeViewModel()
    PortfolioView(vm.coins)
        .environment(vm)
}
