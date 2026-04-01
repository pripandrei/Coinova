//
//  NavigationRouter.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/1/26.
//
import Foundation
import SwiftUI

@Observable
final class NavigationRouter
{
    var homePath: [HomeRoute] = []
    
    func openCoinDetailsScreen(_ coin: Coin)
    {
        homePath.append(.coinDetails(coin))
    }
}
