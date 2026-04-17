//
//  NetworkMonitor.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/17/26.
//

import Network
import Foundation

protocol NetworkMonitorProtocol: AnyObject
{
    var isReachable: Bool { get set }
}

@Observable
final class NetworkMonitor: NetworkMonitorProtocol
{
    private let monitorQueue: DispatchQueue = .init(label: "com.cryptoApp.networkMonitorQueue")
    private let monitor: NWPathMonitor = .init()
    var isReachable: Bool = false
    
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
}
