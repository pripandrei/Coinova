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
                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
            }
        }
        .chartYAxis(.hidden)
//        .chartYAxis {
//            AxisMarks(values: [viewModel.minPrice, viewModel.maxPrice])
//            { value in
//                if let price = value.as(Double.self) {
//                    AxisValueLabel {
//                        Text("$\(price.abbreviated())")
//                    }
//                }
//            }
//        }
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


struct PricePoint: Identifiable
{
    let id: UUID = UUID()
    let date: Date
    let price: Double
}

#if DEBUG
#Preview
{
    CoinHistoryPriceChart(coin: Coin.mockCoins.first!)
}
#endif



// MARK: - animation chart

//
//
//@State private var trimEnd: Double = 0.0  // 👈 controls how much of the line is drawn
//
//
//var body: some View
//{
//    ZStack {
//        // Layer 1: Base chart — axes + grid only, no marks (invisible placeholder)
//        Chart(chartData) { item in
//            // Dummy PointMark to keep axis scale anchored, fully transparent
//            PointMark(
//                x: .value("Time", item.date),
//                y: .value("Price", item.price)
//            )
//            .opacity(0)
//        }
//        .chartYScale(domain: priceRangeY)
//        .chartXScale(domain: priceRangeX)
//        .frame(height: 300)
//
//        // Layer 2: Animated area + line, masked left-to-right
//        Chart(chartData) { item in
//            AreaMark(
//                x: .value("Time", item.date),
//                yStart: .value("Min", minPrice),
//                yEnd: .value("Price", item.price)
//            )
//            .foregroundStyle(
//                LinearGradient(
//                    colors: [.green.opacity(0.6),
//                             .green.opacity(0.5),
//                             .green.opacity(0.4),
//                             .green.opacity(0.3),
//                             .clear],
//                    startPoint: .top,
//                    endPoint: .bottom)
//            )
//
//            LineMark(
//                x: .value("Time", item.date),
//                y: .value("Price", item.price)
//            )
//            .interpolationMethod(.cardinal)
//            .lineStyle(StrokeStyle(lineWidth: 2.0))
//            .foregroundStyle(.green)
//            .shadow(color: .green.opacity(0.7), radius: 20, x: 0, y: 0)
//        }
//        .chartYScale(domain: priceRangeY)
//        .chartXScale(domain: priceRangeX)
////            .chartXAxis(.hidden)
////            .chartYAxis(.hidden)
//        .chartPlotStyle { plotArea in
//            plotArea.background(.clear)
//        }
//        .frame(height: 300)
//        .mask(alignment: .leading) {
//            GeometryReader { geo in
//                Rectangle()
//                    .frame(width: geo.size.width * trimEnd)
//            }
//        }
//    }
//    .onAppear {
//        withAnimation(.linear(duration: 1.5)) {
//            trimEnd = 1.0
//        }
//    }
//}



// MARK: - with index instead of date

//
//
//
////
////  CoinHistoryPriceChart.swift
////  CryptoApp
////
////  Created by Andrei Pripa on 4/11/26.
////
//
//import SwiftUI
//import Charts
//
//struct CoinHistoryPriceChart: View
//{
//    let coin: Coin
//    
//    let chartData: [PricePoint]
//    
//    let minPrice: Double
//    let maxPrice: Double
//    
//    init(coin: Coin)
//    {
//        self.coin = coin
//        self.chartData = Self.getChartData(from: coin)
//        self.minPrice = coin.sparklineIn7d?.price.min() ?? 0.0
//        self.maxPrice = coin.sparklineIn7d?.price.max() ?? 0.0
//    }
//    
//    var body: some View
//    {
//        Chart(chartData) { item in
//
//            AreaMark(
//                x: .value("Time", item.date),
//                yStart: .value("Min", minPrice),
//                yEnd: .value("Price", item.price)
//            )
//            .foregroundStyle(
//                LinearGradient(
//                    colors: [.green.opacity(0.6),
//                             .green.opacity(0.5),
//                             .green.opacity(0.4),
//                             .green.opacity(0.3),
////                             .green.opacity(0.03),
//                             .clear
//                    ],
//                    startPoint: .top,
//                    endPoint: .bottom)
//            )
//            
//            LineMark(x: .value("Time", item.date),
//                     y: .value("Price", item.price))
//            .interpolationMethod(.cardinal)
//            .lineStyle(StrokeStyle(lineWidth: 2.0))
//            .foregroundStyle(.green)
//            .shadow(color: .green.opacity(0.7),
//                    radius: 20,
//                    x: 0,
//                    y: 0)
////                LinearGradient(colors: [.blue, .yellow],
////                               startPoint: .top,
////                               endPoint: .bottom)
////            )
//        }
//        .chartYScale(domain: priceRangeY)
////        .chartXScale(domain: priceRangeX)
////        .chartXAxis(.hidden)
////        .chartYAxis(.hidden)
//        .frame(height: 300)
//    }
//    
////    private var priceRangeX: ClosedRange<Date>
////    {
////        guard let first = chartData.first?.date,
////              let last = chartData.last?.date else {
////            return Date()...Date()
////        }
////
////        let padding: TimeInterval = 60 * 60 * 7
////
////        return first.addingTimeInterval(-padding)...last.addingTimeInterval(padding)
////    }
//    
//    private var priceRangeY: ClosedRange<Double>
//    {
//        let padding = (maxPrice - minPrice) * 0.10
//        return (minPrice - padding)...(maxPrice + padding)
////        return minPrice...maxPrice
//    }
//
//    static private func getChartData(from coin: Coin) -> [PricePoint]
//    {
////        let totalPoints = coin.sparklineIn7d?.price.count ?? 0
////        let secondsIn7Days: Double = 7 * 24 * 60 * 60
////
////        let interval = secondsIn7Days / Double(totalPoints)
////
////        let now = Date()
//        
//        let chartData: [PricePoint] = coin.sparklineIn7d?.price
//            .enumerated()
//            .map { index, price in
////                let timeOffset = Double(totalPoints - index) * interval
////                let date = now.addingTimeInterval(-timeOffset)
//                
//                return PricePoint(date: index, price: price)
//            } ?? []
//        
//        return chartData
//    }
//}
//
//struct PricePoint: Identifiable
//{
//    let id: UUID = UUID()
////    let date: Date
//    let date: Int
//    let price: Double
//}
//
//#Preview
//{
//    CoinHistoryPriceChart(coin: Coin.mockCoins.first!)
//}
