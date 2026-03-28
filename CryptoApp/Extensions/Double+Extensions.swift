//
//  Double+Extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/15/26.
//

import Foundation

extension Double
{
    func abbreviated() -> String
    {
        let abs = abs(self)
        
        switch abs
        {
        case 1_000_000_000_000_000...: return String(format: "%.2fQd", self / 1_000_000_000_000_000)
        case 1_000_000_000_000...: return String(format: "%.2fTr", self / 1_000_000_000_000)
        case 1_000_000_000...: return String(format: "%.2fBn", self / 1_000_000_000)
        case 1_000_000...: return String(format: "%.2fM", self / 1_000_000)
        case 1_000...: return String(format: "%.2fK", self / 1_000)
        default: return String(format: "%.2fK", self)
        }
    }
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 8
        
        return formatter
    }()
    
    static let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    func asCurrenyWithDecimals() -> String
    {
        return Self.currencyFormatter.string(from: (self as NSNumber)) ?? "\(self)"
    }
    
    func asPercentWithDecimals() -> String {
        String(format: "%.2f%%", self)
    }
    
    func asDecimals(_ number: Int = 2) -> String
    {
        return String(format: "%.\(number)f", self)
    }
}
