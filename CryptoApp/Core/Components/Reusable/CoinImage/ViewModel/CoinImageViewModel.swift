//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/15/26.
//

import SwiftUI
import FactoryKit
import Foundation

@Observable
final class CoinImageViewModel
{
    private let coin: Coin
    private(set) var coinImage: UIImage?
    
    @ObservationIgnored
    @Injected(\.imageService) var imageService
    
    init(coin: Coin)
    {
        self.coin = coin
    }
    
    func loadCoinImage() async
    {
        do {
            guard let imageData = try await imageService.loadImage(from: coin.image),
                  let image = UIImage(data: imageData) else {return}
            self.coinImage = image
        } catch {
            print(error.localizedDescription)
        }
    }
}
