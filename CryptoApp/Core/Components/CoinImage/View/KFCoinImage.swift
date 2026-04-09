//
//  KFCoinImage.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/10/26.
//

import Kingfisher
import SwiftUI

struct KFCoinImage: View
{
    private let imagePath: String
    private let size: CGSize
    
    init(imagePath: String,
         size: CGSize = .init(width: 30, height: 30))
    {
        self.imagePath = imagePath
        self.size = size
    }
    
    var body: some View
    {
        KFImage(URL(string: imagePath))
            .memoryCacheExpiration(.expired) // don't store in memory cache, only Disk cache
            .cancelOnDisappear(true)
            .placeholder({ progress in
                ProgressView()
                    .frame(width: size.width, height: size.height)
            })
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipShape(.circle)
            .transaction { $0.animation = nil }
    }
}
