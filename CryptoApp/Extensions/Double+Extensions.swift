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
        case 1_000_000_000_000...: return String(format: "%.2fQd", self / 1_000_000_000_000_000)
        case 1_000_000_000_000...: return String(format: "%.2fTr", self / 1_000_000_000_000)
        case 1_000_000_000...: return String(format: "%.2fBn", self / 1_000_000_000)
        case 1_000_000...: return String(format: "%.2fM", self / 1_000_000)
        case 1_000...: return String(format: "%.2fK",  self / 1_000)
        default: return String(format: "%.2K", self)
        }
    }
    
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "de_DE")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 10
        
        return formatter
    }()
    
    func asCurrenyWithDecimals() -> String
    {
        return Self.formatter.string(from: (self as NSNumber)) ?? "\(self)"
    }
}
