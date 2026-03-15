//
//  Double+Extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/15/26.
//

import Foundation

extension Double
{
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
