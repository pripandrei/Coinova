//
//  StatisticView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/9/26.
//

import SwiftUI

struct StatisticView: View
{
    let statisticData: StatisticModel
    let fontSchema: StatisticFontSchema
    let alignment: HorizontalAlignment
    
    var body: some View
    {
        VStack(alignment: alignment, spacing: 5)
        {
            Text(statisticData.title)
                .font(fontSchema.title)
                .fontWeight(fontSchema.titleWeight)
                .foregroundStyle(Color.theme.secondaryText)
            
            Text(statisticData.value)
                .font(fontSchema.value)
                .fontWeight(fontSchema.valueWeight)
                .foregroundStyle(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            
            if let percentage = statisticData.percentageChange,
               percentage != 0.0
            {
                percentageChangeSymbol(percentage)
//                    .padding(.top, 5)
            }
        }
    }
}

// Views components
extension StatisticView
{
    private func percentageChangeSymbol(_ value: Double) -> some View
    {
        return HStack {
            Image(systemName: value > 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
            Text("\(value.asPercentWithDecimals())")
        }
        .font(fontSchema.percentageChange)
        .fontWeight(fontSchema.percentageWeight)
        .foregroundStyle(value < 0 ? Color.theme.red : Color.theme.green)
    }
}


extension StatisticView
{
    struct StatisticFontSchema
    {
        let (title, titleWeight): (Font, Font.Weight)
        let (value, valueWeight): (Font, Font.Weight)
        let (percentageChange, percentageWeight): (Font, Font.Weight)
    }
}

