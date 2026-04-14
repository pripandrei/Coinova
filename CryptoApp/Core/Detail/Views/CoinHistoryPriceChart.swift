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
    
    var onSelectedPriceChange: ((Double?) -> Void)?
    
    private var displayedPrice: Double
    {
        viewModel.selectedPricePoint?.price ?? viewModel.coin.currentPrice
    }
    
    init(coin: Coin, onSelectedPriceChange: ((Double?) -> Void)? = nil)
    {
        self._viewModel = State(initialValue: CoinHistoryPriceChartViewModel(coin: coin))
        self.onSelectedPriceChange = onSelectedPriceChange
    }
    
    @State private var shouldAnimate: Bool = false
       
    var body: some View
    {
        VStack
        {
//            Text("\(viewModel.selectedPricePoint?.price.asCurrenyWithDecimals() ?? "0.00")")
            Text("\(displayedPrice.asCurrenyWithDecimals())")
                .font(.title)
                .fontWeight(.semibold)
                .monospacedDigit()
                .foregroundStyle(Color.theme.accent)
                .padding(.bottom, 30)
//                .padding(.leading, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack
            {
                priceChartAxisView
                priceChartInteractiveView
            }
        }
        .onChange(of: viewModel.selectedPricePoint?.price) { _, newValue in
            onSelectedPriceChange?(newValue)
        }
    }
}

//MARK: - Charts
extension CoinHistoryPriceChart
{
    private var priceChartAxisView: some View
    {
        Chart
        {
            
        }
        .chartYScale(domain: viewModel.priceRangeY)
        .chartXScale(domain: viewModel.priceRangeX)
        .chartXAxis {
            AxisMarks(values: xAxisMarks) { value in
                AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                    .foregroundStyle(Color.theme.secondaryText)
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis(viewModel.selectionDate == nil ? .visible : .hidden)
//        .opacity(viewModel.selectionDate == nil ? 1.0 : 0.0)
        .animation(.linear(duration: 0.2), value: viewModel.selectionDate == nil)
        .frame(height: 300)
        .onAppear(perform: {
            shouldAnimate = false
            
            withAnimation(.easeInOut(duration: 1.5)) {
                shouldAnimate = true
            }
        })
    }
    
    private var priceChartInteractiveView: some View
    {
        Chart
        {
            ForEach(viewModel.chartData) { item in
                buildPriceEvolutionAreaMark(from: item)
                buildPriceEvolutionLineMark(from: item)
            }
            buildSelectionLine
        }
        
        .chartXSelection(value: $viewModel.selectionDate)
        .chartYScale(domain: viewModel.priceRangeY)
//        .chartXScale(domain: viewModel.priceRangeX)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .mask(alignment: .leading) {
            Rectangle()
                .frame(maxWidth: shouldAnimate ? .infinity : 0)
                .padding(.top, -20)
        }
        .chartOverlay { proxy in
            getTopPriceMark(inChartProxy: proxy)
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
            LinearGradient(
                colors: [
                    chartLineMarkAttributesColor.opacity(0.5),
                    chartLineMarkAttributesColor.opacity(0.01),
//                    .clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // price evolution mark
    private func buildPriceEvolutionLineMark(from item: PricePoint) -> some ChartContent
    {
        LineMark(x: .value("Time", item.date),
                 y: .value("Price", item.price))
        .interpolationMethod(.cardinal)
        .lineStyle(StrokeStyle(lineWidth: 2.0))
        .foregroundStyle(chartLineMarkAttributesColor.gradient)
        .shadow(color: chartLineMarkAttributesColor.opacity(0.4),
                radius: 10,
                x: 0,
                y: 5)
    }
    
    // selection line
    @ChartContentBuilder
    private var buildSelectionLine: some ChartContent
    {
        if let selectedPoint = viewModel.selectedPricePoint
        {
            RuleMark(x: .value("Date", selectedPoint.date),
                     yStart: .value("Start", viewModel.minPrice),
                     yEnd: .value("End", viewModel.maxPrice)
            )
                .foregroundStyle(.gray)
                .lineStyle(.init(lineWidth: 1, dash: [3]))
                .annotation(position: .top,
                            overflowResolution: .init(x: .fit(to: .chart),
                                                      y: .disabled))
            {
                Text(viewModel.selectionDate?.toMMDDHHmm ?? "")
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .monospacedDigit() // for preventig jitter
                    .padding(5)
                    .background(ruleMarkAttributesColor.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            PointMark(x: .value("Date", selectedPoint.date),
                      y: .value("Price", selectedPoint.price))
            .foregroundStyle(ruleMarkAttributesColor)
            .symbolSize(200)
//
            PointMark(
                x: .value("Date", selectedPoint.date),
                y: .value("Price", selectedPoint.price)
            )
            .foregroundStyle(.white)
            .symbolSize(70)
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

    private var ruleMarkAttributesColor: Color
    {
        guard let firstPrice = viewModel.chartData.first?.price, let lastPrice = viewModel.chartData.last?.price else {return .gray}
        
        if firstPrice < lastPrice
        {
            return Color.theme.secondaryGreen
        }
        return Color.theme.red
    }
    
    private var chartLineMarkAttributesColor: Color
    {
        guard let firstPrice = viewModel.chartData.first?.price, let lastPrice = viewModel.chartData.last?.price else {return .gray}
        
        if firstPrice < lastPrice
        {
            return Color.theme.green
        }
        return Color.theme.red
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

