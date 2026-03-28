//
//  GRDatabase.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/24/26.
//

import Foundation
import GRDB
import Combine

typealias DBColumn = Column

final class GRDBDatabase
{
    private let dbQueue: DatabaseQueue
    
    init() throws
    {
        let url = try FileManager.default
            .url(for: .applicationSupportDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appending(component: "cryptoApp.db.sqlite")

        self.dbQueue = try DatabaseQueue(path: url.path(percentEncoded: false))
        
        try migrate()
        
        #if DEBUG || DEV
        print("📂 DB PATH: \(url.path())")
        #endif
    }
    
    private func migrate() throws
    {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1") { db in
            try db.create(table: Coin.databaseTableName, ifNotExists: true) { t in
                t.primaryKey("id", .text).notNull()
                t.column("symbol", .text).notNull()
                t.column("name", .text).notNull()
                t.column("image", .text).notNull()
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

extension GRDBDatabase
{
    // save data
    func save<T: PersistableRecord>(_ object: T)
    {
        do {
            try dbQueue.write { db in
                try object.save(db)
            }
        } catch {
            print("📂 Error while saving object to database: \(error)")
        }
    }
    
    // fetch data
    func fetch<T: FetchableRecord & PersistableRecord>(type: T.Type,
                                                       filter: SQLExpression? = nil) throws -> [T]
    {
        try dbQueue.read { db in
            if let filter {
                return try T.filter(filter).fetchAll(db)
            }
            return try T.fetchAll(db)
        }
    }
    
    func fetch<T: FetchableRecord & PersistableRecord>(type: T.Type, by id: String) throws -> T?
    {
        try dbQueue.read { db in
            try type.fetchOne(db, key: id)
        }
    }
    
    // observe data
    
    
    func observe<T: FetchableRecord & PersistableRecord>(type: T.Type,
                                                         filter: SQLExpression? = nil) -> AnyPublisher<[T], Error>
    {
        let observation = ValueObservation.tracking { db in
            if let filter {
                return try T.filter(filter).fetchAll(db)
            }
            return try T.fetchAll(db)
        }
        
        return observation
            .publisher(in: dbQueue)
            .eraseToAnyPublisher()
    }
    
//
//    func retrieveObjects<T: FetchableRecord & TableRecord>(ofType type: T.Type,
//                                                           filter: String? = nil,
//                                                           arguments: [Any] = []) throws -> [T]
//    {
//        try dbQueue.read { db in
//            if let filter
//            {
//                let statement = StatementArguments(arguments) ?? StatementArguments()
//                return try T.filter(sql: filter,
//                                    arguments: statement).fetchAll(db)
//            }
//            return try T.fetchAll(db)
//        }
//    }
}

