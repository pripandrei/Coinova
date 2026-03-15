//
//  CacheService.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/15/26.
//

import Foundation

protocol DataCacheable
{
    func store(data: Data, for key: String)
    func retrieveData(for key: String) -> Data?
}

final class CacheService: DataCacheable
{
    private var cacheDirectory: URL
    {
        return FileManager.default.urls(for: .cachesDirectory,
                                        in: .userDomainMask)[0]
            .appending(path: "ImageCache", directoryHint: .isDirectory)
    }
    
    init()
    {
        try? FileManager.default.createDirectory(at: cacheDirectory,
                                                 withIntermediateDirectories: true)
    }
    
    func store(data: Data, for key: String)
    {
        let file = cacheDirectory.appending(path: key.toSafeFilename())
        
        do {
            try data.write(to: file)
            print("Successfully cached data: \(file.path())")
        } catch {
            print("Error caching data: \(error.localizedDescription)")
        }
    }
    
    func retrieveData(for key: String) -> Data?
    {
        let file = cacheDirectory.appending(path: key.toSafeFilename())
        do
        {
            return try Data(contentsOf: file)
        } catch {
            print("Could not retrieve data from cache: \(error)")
            return nil
        }
    }
}

