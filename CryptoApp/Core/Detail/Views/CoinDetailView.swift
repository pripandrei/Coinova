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
                sectionTitle("Overview")
                
                description
                
                overviewGridInfo
                
                sectionTitle("Additional Details")
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
                    coinImage
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
    private var description: some View
    {
        Text(viewModel.coinDetails?.description?.en ?? "")
            .font(.body)
            .withTruncationEffect(3)
            .frame(maxWidth: .infinity, alignment: .leading)
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
        LazyVGrid(columns: columns, spacing: 30)
        {
            ForEach(viewModel.overview) { stat in
                StatisticView(statisticData: stat,
                              fontSchema: Self.statisticFontSchema)
//                .padding(.horizontal, 20)
            }
        }
    }
    
    private var additionalDetailsGridInfo: some View
    {
        LazyVGrid(columns: columns, spacing: 30)
        {
            
        }
    }
    
    static let statisticFontSchema: StatisticView.StatisticFontSchema = .init(
        title: .caption,
        titleWeight: .medium,
        value: .headline,
        valueWeight: .semibold,
        percentageChange: .caption2,
        percentageWeight: .medium
    ) 
}

//MARK: - Navigation items
extension CoinDetailScreen
{
    private var coinImage: some View
    {
        KFImage(URL(string: viewModel.coin.image))
            .memoryCacheExpiration(.expired) // don't store in memory cache, only Disk cache
            .cancelOnDisappear(true)
            .placeholder({ progress in
                ProgressView()
                    .frame(width: 30, height: 30)
            })
            .resizable()
            .scaledToFill()
            .frame(width: 30, height: 30)
            .clipShape(.circle)
            .transaction { $0.animation = nil }
    }
}

#if DEBUG
#Preview
{
    CoinDetailScreen(coin: Coin.mockCoins.first!)
}
#endif


