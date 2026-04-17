//
//  NetworkMonitor.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/17/26.
//

import Network
import Foundation
import Combine

protocol NetworkMonitorProtocol: AnyObject
{
    var isReachable: Bool { get set }
    func waitUntilNetworkIsReachable(withTimeout timeoutInSeconds: Double) async throws
}


@Observable
final class NetworkMonitor: NetworkMonitorProtocol
{
    private let monitorQueue: DispatchQueue = .init(label: "com.cryptoApp.networkMonitorQueue")
    private let monitor: NWPathMonitor = .init()
    var isReachable: Bool = false
    var cancellables: Set<AnyCancellable> = []
    
    init()
    {
        startNetworkMonitor()
    }
    
    private func startNetworkMonitor()
    {
        monitor.pathUpdateHandler = { path in
            self.isReachable = (path.status == .satisfied)
        }
        monitor.start(queue: monitorQueue)
    }
    
//    func waitUntilNetworkIsReachable1() async
//    {
//        if isReachable { return }
//
//        await withCheckedContinuation { continuation in
//            var cancellable: AnyCancellable?
//
//            cancellable = self.$isReachable
//                .sink { isReachable in
//                    if isReachable {
//                        continuation.resume()
//                        cancellable?.cancel()
//                    }
//                }
//        }
//    }
    
    func waitUntilNetworkIsReachable(withTimeout timeoutInSeconds: Double = 30) async throws
    {
        let date = Date()
        
        while !isReachable
        {
            let timeElapsed = Date().timeIntervalSince(date)
            if timeElapsed > timeoutInSeconds { throw NetworkError.noInternetConnection }
            try await Task.sleep(for: .seconds(5))
        }
    }
}
