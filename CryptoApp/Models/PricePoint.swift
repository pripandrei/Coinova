//
//  PricePoint.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/12/26.
//

import Foundation

struct PricePoint: Identifiable
{
    let id: UUID = UUID()
    let date: Date
    let price: Double
}
