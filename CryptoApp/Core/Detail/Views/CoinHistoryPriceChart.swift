//
//  CoinHistoryPriceChart.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/11/26.
//

import SwiftUI
import Charts

struct CoinHistoryPriceChart: View
{
    @State private var viewModel: CoinHistoryPriceChartViewModel

    init(coin: Coin)
    {
        self._viewModel = State(initialValue: CoinHistoryPriceChartViewModel(coin: coin))
    }
    
    @State private var shouldAnimate: Bool = false
       
    var body: some View
    {
        Chart(viewModel.chartData) { item in
            
        }
        .chartYScale(domain: viewModel.priceRangeY)
        .chartXScale(domain: viewModel.priceRangeX)
        .chartXAxis {
            AxisMarks(values: xAxisMarks) { value in
                AxisValueLabel(format: .dateTime.day().month(.abbreviated))
//                    .offset(y: 20)
            }
        }
        .chartYAxis(.hidden)
        .frame(height: 300)
        .chartOverlay(alignment: .leading, content: { proxy in
//            GeometryReader { geo in
                Chart(viewModel.chartData) { item in
                    buildAreaMark(from: item)
                    buildLineMark(from: item)
                }
                .chartYScale(domain: viewModel.priceRangeY)
//                .chartXScale(domain: viewModel.priceRangeX)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(width: proxy.plotSize.width)
                .frame(height: proxy.plotSize.height)
//            }
            .mask(alignment: .leading) {
                Rectangle()
                    .frame(maxWidth: shouldAnimate ? .infinity : 0)
            }
            
            getTopPriceMark(inChartProxy: proxy)
        })
        .onAppear(perform: {
            shouldAnimate = false
            
            withAnimation(.easeInOut(duration: 1.5)) {
                shouldAnimate = true
            }
        })
    }

    var xAxisMarks: [Date]
    {
        guard let first = viewModel.chartData.first?.date,
              let last = viewModel.chartData.last?.date else { return [] }

        return [first, last]
    }
    
//    func getSevenDays() -> [Date] {
//        let uniqueDays = Set(viewModel.chartData.map {
//            Calendar.current.startOfDay(for: $0.date)
//        })
//        return uniqueDays.sorted()
//    }
}

extension Date
{
    static func from(year: Int, month: Int, day: Int) -> Date
    {
        let component = DateComponents(year: year,
                                       month: month,
                                       day: day)
        return Calendar.current.date(from: component)!
    }
}

//MARK: - view components
extension CoinHistoryPriceChart
{
    private func buildAreaMark(from item: PricePoint) -> some ChartContent
    {
        AreaMark(
            x: .value("Time", item.date),
            yStart: .value("Min", viewModel.minPrice),
            yEnd: .value("Price", item.price)
        )
        .foregroundStyle(
            LinearGradient(
                colors: [.green.opacity(0.6),
                         .green.opacity(0.5),
                         .green.opacity(0.4),
                         .green.opacity(0.3),
//                             .green.opacity(0.03),
                         .clear
                ],
                startPoint: .top,
                endPoint: .bottom)
        )
    }
    
    private func buildLineMark(from item: PricePoint) -> some ChartContent
    {
        LineMark(x: .value("Time", item.date),
                 y: .value("Price", item.price))
        .interpolationMethod(.cardinal)
        .lineStyle(StrokeStyle(lineWidth: 2.0))
        .foregroundStyle(.green)
        .shadow(color: .green.opacity(0.7),
                radius: 10,
                x: 0,
                y: 0)
    }
    
    @ViewBuilder
    private func getTopPriceMark(inChartProxy proxy: ChartProxy) -> some View
    {
        if let maxPrice = viewModel.maxPricePoint,
            let xPosition = proxy.position(forX: maxPrice.date),
            let yPosition = proxy.position(forY: maxPrice.price)
        {
            Text("$\(maxPrice.price.abbreviated())")
                .font(.footnote)
                .foregroundStyle(Color.theme.secondaryText)
                .position(x: xPosition + 20,
                          y: yPosition - 10)
                .opacity(shouldAnimate ? 1.0 : 0.0)
                .animation(.linear(duration: 0.5),
                           value: shouldAnimate)
        } else {
            EmptyView()
        }
    }
}

#if DEBUG
#Preview
{
    CoinHistoryPriceChart(coin: Coin.mockCoins.first!)
}
#endif

