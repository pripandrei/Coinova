//
//  ImageService.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/15/26.
//

import Foundation
import FactoryKit

protocol ImageDownloadable
{
    func loadImage(from path: String) async throws -> Data?
}

final class ImageLoader: ImageDownloadable
{
    @Injected(\.cacheService) var cacheService
    
    func loadImage(from path: String) async throws -> Data?
    {
        if let data = cacheService.retrieveData(for: path)
        {
            return data
        }
        
        guard let url = URL(string: path) else { throw NetworkError.invalidPath }
        let (data, response) = try await URLSession.shared.data(from: url)
        try NetworkingManager.handleURLResponse(response)
        
        cacheService.store(data: data, for: path)
        
        return data
    }
}
