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
        VStack
        {
            Text("\(viewModel.selectedPricePoint?.price.asCurrenyWithDecimals() ?? "0.0")")
            ZStack
            {
                priceChartAxisView
                priceChartInteractiveView
            }
        }
    }
}

//MARK: - Charts
extension CoinHistoryPriceChart
{
    private var priceChartAxisView: some View
    {
        Chart(viewModel.chartData) { item in
            
        }
        .chartYScale(domain: viewModel.priceRangeY)
        .chartXScale(domain: viewModel.priceRangeX)
        .chartXAxis {
            AxisMarks(values: xAxisMarks) { value in
                AxisValueLabel(format: .dateTime.day().month(.abbreviated))
//                    .foregroundStyle(viewModel.selectionDate == nil ? .secondaryText : .clear)
            }
        }
        .chartYAxis(.hidden)
//        .chartXAxis(viewModel.selectionDate == nil ? .visible : .hidden)
        .opacity(viewModel.selectionDate == nil ? 1.0 : 0.0)
        .animation(.linear(duration: 0.2), value: viewModel.selectionDate == nil)
        .frame(height: 300)
        //        .onChange(of: selectedPricePoint?.price, { oldValue, newValue in
        //            print(newValue)
        //        })
        .onAppear(perform: {
            shouldAnimate = false
            
            withAnimation(.easeInOut(duration: 1.5)) {
                shouldAnimate = true
            }
        })
    }
    
    private var priceChartInteractiveView: some View
    {
        Chart(viewModel.chartData) { item in
            buildPriceEvolutionAreaMark(from: item)
            buildPriceEvolutionLineMark(from: item)
        }
        .chartXSelection(value: $viewModel.selectionDate)
        .chartYScale(domain: viewModel.priceRangeY)
//        .chartXScale(domain: viewModel.priceRangeX)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .mask(alignment: .leading) {
            Rectangle()
                .frame(maxWidth: shouldAnimate ? .infinity : 0)
        }
        .chartOverlay { proxy in
            getTopPriceMark(inChartProxy: proxy)
            VStack
            {
                if let date = viewModel.selectionDate,
                   let x = proxy.position(forX: date) {
                    Text(viewModel.selectionDate?.toMMDD ?? "")
                        .fixedSize()
                        .offset(x: x - proxy.plotSize.width / 2) // center-adjust manually
                    buildSelectionLinePath(withProxy: proxy)
                }
            }
        }
        .frame(height: 300)
    }
}

//MARK: - View components
extension CoinHistoryPriceChart
{
    // price evolution area
    private func buildPriceEvolutionAreaMark(from item: PricePoint) -> some ChartContent
    {
        AreaMark(
            x: .value("Time", item.date),
            yStart: .value("Min", viewModel.minPrice),
            yEnd: .value("Price", item.price)
        )
        .foregroundStyle(
//            LinearGradient(
//                colors: [.green.opacity(0.6),
//                         .green.opacity(0.5),
//                         .green.opacity(0.4),
//                         .green.opacity(0.3),
////                             .green.opacity(0.03),
//                         .clear
//                ],
//                startPoint: .top,
//                endPoint: .bottom)
            LinearGradient(
                colors: [.green.opacity(0.25), .clear],
                startPoint: .top, endPoint: .bottom
            )
        )
//        .interpolationMethod(.catmullRom)
        
    }
    
    // price evolution mark
    private func buildPriceEvolutionLineMark(from item: PricePoint) -> some ChartContent
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
    
    // selection line
    @ViewBuilder
    private func buildSelectionLinePath(withProxy proxy: ChartProxy) -> some View
    {
        if let date = viewModel.selectionDate,
           let x = proxy.position(forX: date)
        {
            Path { path in
                path.move(to: .init(x: x, y: 0))
                path.addLine(to: .init(x: x, y: proxy.plotSize.height))
            }
            .stroke(style: .init(lineWidth: 1, dash: [3]))
            .foregroundStyle(.green)
        } else {
            EmptyView()
        }
    }
    
    // top price
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
                .position(x: xPosition - 20,
                          y: yPosition - 10)
                .opacity(shouldAnimate ? 1.0 : 0.0)
                .animation(.linear(duration: 0.5),
                           value: shouldAnimate)
                .opacity(viewModel.selectionDate == nil ? 1.0 : 0.0)
                .animation(.snappy(duration: 0.2),
                           value: viewModel.selectionDate)
        }
    }
}

//MARK: - Helpers
extension CoinHistoryPriceChart
{
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

#if DEBUG
#Preview
{
    CoinHistoryPriceChart(coin: Coin.mockCoins.first!)
}
#endif

