//
//  HomeStatsView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/15/26.
//

import SwiftUI

struct HomeStatsView: View
{
    private let spacing: CGFloat = 15
    var showPortfolio: Bool
    @Environment(HomeViewModel.self) var homeVM
    
    var body: some View
    {
        GeometryReader { proxy in
            HStack(spacing: spacing - 5) {
                ForEach(homeVM.marketStatistics) { statisticData in
                    VStack(alignment: .leading)
                    {
                        Text(statisticData.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.theme.secondaryText)
                        Text(statisticData.value)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.theme.accent)

                        if let percentage = statisticData.percentageChange,
                           percentage != 0.0
                        {
                            percentageChangeSymbol(percentage)
                        }
                    }
                    .frame(width: (proxy.size.width / 3) - spacing)
                    .frame(maxHeight: .infinity, alignment: .top)
//                    .background(.green)
                }
            }
            .padding(.horizontal, spacing / 2)
            .frame(width: proxy.size.width,
                   alignment: showPortfolio ? .trailing : .leading)
            .frame(maxHeight: .infinity)
        } 
        .frame(height: 70)
        .task {
            // TODO: - uncomment when done testing-
//            homeVM.observe()
            await homeVM.getMarketStats()
        }
//        .background(.blue)
    }
}

// Views components
extension HomeStatsView
{
    private func percentageChangeSymbol(_ value: Double) -> some View
    {
        return HStack {
            Image(systemName: value > 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
            Text("\(value.asPercentWithDecimals())")
        }
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundStyle(value < 0 ? Color.theme.red : Color.theme.green)
    }
}

struct HomeStatsView2: View
{
    @State var position: Int? = 0
    
    var body: some View
    {
        ScrollView(.horizontal)
        {
            HStack(spacing: 0) {
                ForEach(0..<4) { index in
                    Text("Some")
                        .font(.title)
                        .containerRelativeFrame(.horizontal,
                                                count: 3,
                                                spacing: 0)
                        .id(index)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollDisabled(true)
        .frame(height: 70)
        .background(.blue.opacity(0.3))
        .scrollPosition(id: $position)
        
        
        Button {
            withAnimation(.snappy(duration: 0.5)) {
                position = position == 0 ? 3 : 0
            }
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
                .frame(width: 150, height: 50)
                .overlay {
                    Text("Tap me")
                        .font(.title)
                }
        }
    }
}


#Preview {
//    let homeVM = DeveloperPreview.instance.makeMockHomeViewModel()
//    HomeStatsView(homeVM: homeVM)
    HomeStatsView(showPortfolio: false)
//        .environment(DeveloperPreview.instance.makeMockHomeViewModel())
        .environment(HomeViewModel())
}
