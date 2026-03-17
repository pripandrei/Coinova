//
//  HomeStatsView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/15/26.
//

import SwiftUI

struct HomeStatsView: View
{
    @State var showPortfolio: Bool = true
    @Environment(HomeViewModel.self) var homeVM
    
    var body: some View
    {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(homeVM.marketStatistics) { statisticData in
                    VStack
                    {
                        Text(statisticData.title)
                        Text(statisticData.value)
                    }
                    .frame(width: proxy.size.width / 3)
                }
            }
            .frame(width: proxy.size.width,
                   alignment: showPortfolio ? .leading : .trailing)
            .frame(maxHeight: .infinity)
            .background(.orange)
        }
        .frame(height: 100)
        .background(.blue.opacity(0.5))
        .task {
            homeVM.observe()
            await homeVM.getMarketStats()
        }
        
        Button {
            withAnimation(.snappy(duration: 0.5)) {
                showPortfolio.toggle()
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
    HomeStatsView()
        .environment(HomeViewModel())
}
