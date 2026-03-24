//
//  GRDatabase.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/24/26.
//

import Foundation
import GRDB

final class GRDBDatabase
{
    private let dbQueue: DatabaseQueue
    
    init() throws
    {
        let url = FileManager.default
            .urls(for: .applicationSupportDirectory,
                  in: .userDomainMask)
            .first!
            .appending(path: "cryptoApp.db.sqlite")
        
        self.dbQueue = try DatabaseQueue(path: url.path())
        
        try migrate()
        
        print("📂 DB PATH: \(url.path())")
    }
    
    private func migrate() throws
    {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1") { db in
            try db.create(table: "coin", ifNotExists: true) { t in
                t.primaryKey("id", .text).notNull()
                t.column("symbol", .text).notNull()
                t.column("name", .text).notNull()
                t.column("image", .text).notNull()
                t.column("current_price", .double).notNull()
                t.column("current_price", .double).notNull()
                t.column("market_cap", .double)
                t.column("market_cap_rank", .integer)
                t.column("fully_diluted_valuation", .double)
                t.column("total_volume", .double)
                t.column("high_24h", .double)
                t.column("low_24h", .double)
                t.column("price_change_24h", .double)
                t.column("price_change_percentage_24h", .double)
                t.column("market_cap_change_24h", .double)
                t.column("market_cap_change_percentage_24h", .double)
                t.column("circulating_supply", .double)
                t.column("total_supply", .double)
                t.column("max_supply", .double)
                t.column("ath", .double)
                t.column("ath_change_percentage", .double)
                t.column("ath_date", .text)
                t.column("atl", .double)
                t.column("atl_change_percentage", .double)
                t.column("atl_date", .text)
                t.column("last_updated", .text)
                t.column("sparkline_in_7d", .text)   // JSON-encoded
                t.column("price_change_percentage_24h_in_currency", .double)
                t.column("current_holdings", .double)
            }
        }
        
        try migrator.migrate(dbQueue)
    }
}
