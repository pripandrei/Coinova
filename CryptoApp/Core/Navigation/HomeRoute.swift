//
//  HomeRoute.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/1/26.
//

enum HomeRoute: Hashable
{
    case coinDetails(Coin)
//    case settings
    
    var id: Self { self }
}
