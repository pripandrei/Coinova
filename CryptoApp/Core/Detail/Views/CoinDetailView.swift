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

                description

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
    private var description: some View
    {
        Text(viewModel.coinDetails?.description?.en ?? "")
            .font(.body)
            .withTruncationEffect(3)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
  
//    @ViewBuilder
//    private var description2: some View
//    {
//        VStack(alignment: .leading, spacing: 0)
//        {
//            Text(tempText)
//                .font(.title2)
//                .multilineTextAlignment(.leading)
////                .padding(.bottom, 8)
//                .frame(
//                    height: showFullDescription ? textHeight : collapsedHeight,
//                    alignment: .topLeading
//                )
//                .clipped()
//                // Hidden full-size copy just for measurement
//                .background(
//                    Text(tempText)
//                        .font(.title2)
//                        .multilineTextAlignment(.leading)
////                        .padding(.bottom, 8)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .hidden()
//                        .background(
//                            Color.clear
//                                .onGeometryChange(for: CGFloat.self, of: { geo in
//                                    geo.size.height
//                                }, action: { newValue in
//                                    textHeight = newValue
//                                })
//                        )
//                )
//
//            if textHeight > collapsedHeight {
//                Button {
//                    descriptionSizeChanged.toggle()
//                    withAnimation(.easeOut(duration: 0.5)) {
//                        showFullDescription.toggle()
//                    }
//                } label: {
//                    Text(descriptionSizeChanged ? "Read less..." : "Read more...")
//                        .font(.callout)
//                        .foregroundColor(.blue)
//                        .padding(.bottom, 8)
//                }
//            }
//        }
//    }
    
    
//    @ViewBuilder
//    private var description3: some View
//    {
//        VStack(alignment: .leading, spacing: 10)
//        {
//            Text(viewModel.coinDetails?.description?.en ?? "")
////                .font(.callout)
//                .lineLimit(showFullDescription ? nil : 3)
////                .multilineTextAlignment(.leading)
//            
//            Button {
//                withAnimation(.linear) {
//                    showFullDescription.toggle()
//                }
//            } label: {
//                Text("Read more...")
////                    .font(.subheadline)
//                    .foregroundStyle(.link)
//            }
//        }
////        .frame(maxWidth: .infinity)
//    }
    
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


