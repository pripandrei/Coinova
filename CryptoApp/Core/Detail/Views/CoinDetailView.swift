//
//  CoinDetailView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/1/26.
//

import SwiftUI
import Kingfisher

struct CoinDetailScreen: View
{
    @State private var viewModel: CoinDetailViewModel
    
    private let columns: [GridItem] = [
        .init(.flexible(), alignment: .leading),
        .init(.flexible(), alignment: .leading)
    ]
    
    init(coin: Coin) {
        self._viewModel = State(wrappedValue: .init(coin: coin))
    }
    
    var body: some View
    {
        ScrollView(.vertical)
        {
            VStack(spacing: 30)
            {
                CoinHistoryPriceChart(coin: viewModel.coin)
                
                sectionTitle("Overview")
                
                description
                    .loadingIndicator(viewModel.overview.isEmpty, size: 30)
                
                overviewGridInfo
                
                sectionTitle("Additional Details")
                
                additionalDetailsGridInfo
                    .loadingIndicator(viewModel.overview.isEmpty, size: 30)
                
               links
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle(viewModel.coin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing)
            {
                HStack(spacing: 15)
                {
                    Text(viewModel.coin.symbol.uppercased())
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.theme.accent)
                    KFCoinImage(imagePath: viewModel.coin.image)
                }
            }
            .hideToolbarInteractionIfNeeded()
        }
        .task {
            do
            {
                try await viewModel.getCoinDetails()
                viewModel.createDataStats()
            } catch {
                print("Error fetching coin details: \(error.localizedDescription)")
            }
        }
    }
}

//MARK: View components
extension CoinDetailScreen
{
    @ViewBuilder
    private var description: some View
    {
        if let description = viewModel.coinDetails?.description?.en,
           !description.isEmpty
        {
            Text(description)
                .font(.body)
                .withTruncationEffect(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            EmptyView()
        }
    }

    private func sectionTitle(_ title: String) -> some View
    {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGridInfo: some View
    {
        LazyVGrid(columns: columns, spacing: 25)
        {
            ForEach(viewModel.overview) { stat in
                StatisticView(statisticData: stat,
                              fontSchema: Self.statisticFontSchema,
                              alignment: .leading)
//                .padding(.horizontal, 20)
            }
        }
    }
    
    private var additionalDetailsGridInfo: some View
    {
        LazyVGrid(columns: columns, spacing: 25)
        {
            ForEach(viewModel.additionalDetails) { stat in
                StatisticView(statisticData: stat,
                              fontSchema: Self.statisticFontSchema,
                              alignment: .leading)
            }
        }
    }
    
    private var links: some View
    {
        VStack(alignment: .leading, spacing: 15)
        {
            if let url = URL(string: viewModel.coinDetails?.links?.homepage.first ?? "")
            {
                Link(destination: url) {
                    Text("Website")
                        .foregroundStyle(.link)
                }
            }
            
            if let url = URL(string: viewModel.coinDetails?.links?.subredditUrl ?? "")
            {
                Link(destination: url) {
                    Text("Reddit")
                        .foregroundStyle(.link)
                }
            }
        }
        .font(.body)
        .fontWeight(.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    static let statisticFontSchema: StatisticView.StatisticFontSchema = .init(
        title: .caption,
        titleWeight: .medium,
        value: .headline,
        valueWeight: .semibold,
        percentageChange: .caption,
        percentageWeight: .medium
    ) 
}


#if DEBUG
#Preview
{
    CoinDetailScreen(coin: Coin.mockCoins.first!)
}
#endif


