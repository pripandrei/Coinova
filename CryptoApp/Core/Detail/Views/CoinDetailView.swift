//
//  CoinDetailView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/1/26.
//

import SwiftUI

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
                
                overviewGridInfo
                
                sectionTitle("Additional Details")
            }
        }
        .padding(.horizontal, 20)
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

#if DEBUG
#Preview
{
    CoinDetailScreen(coin: Coin.mockCoins.first!)
}
#endif
