//
//  Date+Extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/14/26.
//

import Foundation

extension Date
{
    var toMMDD: String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: self)
    }
}
