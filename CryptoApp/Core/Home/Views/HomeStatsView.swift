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
            HStack(spacing: spacing) {
                ForEach(homeVM.marketStatistics) { statisticData in
                    StatisticView(statisticData: statisticData,
                                  fontSchema: Self.statisticFontSchema, alignment: .center)
                    .frame(width: (proxy.size.width / 3) - spacing, alignment: .center)
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .padding(.horizontal, spacing / 2)
            .frame(width: proxy.size.width,
                   alignment: showPortfolio ? .trailing : .leading)
            .frame(maxHeight: .infinity)
        }
        .frame(height: 70)
        .task {
            await homeVM.getMarketStats()
        }
    }
}

extension HomeStatsView
{
    static let statisticFontSchema: StatisticView.StatisticFontSchema = .init(title: .subheadline,
              titleWeight: .medium,
              value: .title3,
              valueWeight: .semibold,
              percentageChange: .subheadline,
              percentageWeight: .medium)
}



//
//struct HomeStatsView: View
//{
//    private let spacing: CGFloat = 10
//    var showPortfolio: Bool
//    
//    @Environment(HomeViewModel.self) var homeVM
//    @State private var scrollPosition: Int? = 0
//    
//    var body: some View
//    {
//        ScrollView(.horizontal)
//        {
//            HStack(spacing: spacing) {
//                ForEach(Array(homeVM.marketStatistics.enumerated()), id: \.element.id) { index, statisticData in
//                    StatisticView(statisticData: statisticData,
//                                  fontSchema: Self.statisticFontSchema)
//                    .containerRelativeFrame(.horizontal,
//                                            count: 3,
//                                            spacing: spacing)
//                    .frame(maxHeight: .infinity, alignment: .top)
//                    .id(index)
//                }
//            }
//        }
//        .contentMargins(.horizontal, spacing)
//        .scrollIndicators(.hidden)
//        .scrollDisabled(true)
//        .frame(height: 70)
//        .scrollPosition(id: $scrollPosition)
//        .onChange(of: showPortfolio) { _, newValue in
//            withAnimation(.snappy(duration: 0.5)) {
//                scrollPosition = newValue ? homeVM.marketStatistics.count - 1 : 0
//            }
//        }
//        .task {
//            await homeVM.getMarketStats()
//        }
//    }
//}


//
//struct HomeStatsView2: View
//{
//    @State var position: Int? = 0
//
//    var body: some View
//    {
//        ScrollView(.horizontal)
//        {
//            HStack(spacing: 0) {
//                ForEach(0..<4) { index in
//                    Text("Some")
//                        .font(.title)
//                        .containerRelativeFrame(.horizontal,
//                                                count: 3,
//                                                spacing: 0)
//                        .id(index)
//                }
//            }
//        }
//        .scrollIndicators(.hidden)
//        .scrollDisabled(true)
//        .frame(height: 70)
//        .background(.blue.opacity(0.3))
//        .scrollPosition(id: $position)
//
//
//        Button {
//            withAnimation(.snappy(duration: 0.5)) {
//                position = position == 0 ? 3 : 0
//            }
//        } label: {
//            RoundedRectangle(cornerRadius: 10)
//                .fill(Color.blue)
//                .frame(width: 150, height: 50)
//                .overlay {
//                    Text("Tap me")
//                        .font(.title)
//                }
//        }
//    }
//}
//

#Preview {
//    let homeVM = DeveloperPreview.instance.makeMockHomeViewModel()
//    HomeStatsView(homeVM: homeVM)
    HomeStatsView(showPortfolio: false)
//        .environment(DeveloperPreview.instance.makeMockHomeViewModel())
        .environment(HomeViewModel())
}
