//
//  GRDatabase.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/24/26.
//

import Foundation
import GRDB

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
//
//    func fetchTest_2<T: FetchableRecord & PersistableRecord>(
//        _ request: QueryInterfaceRequest<T>
//    ) throws -> [T] {
//        try dbQueue.read { db in
//            try request.fetchAll(db)
//        }
//    }
    
//    func fetchTest<T: FetchableRecord & PersistableRecord>(type: T.Type,
//                                                           filter: (any SQLSpecificExpressible)? = nil) throws -> [T]
//    {
//       try dbQueue.read { db in
//           if let filter {
//              return try T.filter(filter)
//                   .fetchAll(db)
//           }
//           return try T.fetchAll(db)
//        }
//    }
//    
//    func fetch2<T: FetchableRecord & TableRecord>(_ type: T.Type,
//                                                 where filter: (T.Type) -> QueryInterfaceRequest<T>) throws -> [T]
//    {
//        try dbQueue.read { db in
//            try filter(type).fetchAll(db)
//        }
//    }
//    
//    func retrieveObjects<T: FetchableRecord & TableRecord>(
//        ofType type: T.Type,
//        filter: SQLSpecificExpressible? = nil
//    ) throws -> [T] {
//        try dbQueue.read { db in
//            if let filter {
//                return try T.filter(filter).fetchAll(db)
//            }
//            return try T.fetchAll(db)
//        }
//    }
//    
    func retrieveObjects_2<T: FetchableRecord & TableRecord>(ofType type: T.Type,
                                                           filter: String? = nil,
                                                           arguments: StatementArguments = []) throws -> [T]
    {
        try dbQueue.read { db in
            if let filter
            {
                return try T.filter(sql: filter,
                                    arguments: arguments).fetchAll(db)
            }
            return try T.fetchAll(db)
        }
    }
    
//    func retrieveCoins<T: FetchableRecord & TableRecord>(ofType type: T.Type ,
//                                                         filter: Filter? = nil) throws -> [T]
//    {
//        try dbQueue.read { db in
//            if let filter {
//                return try type.filter(filter.expression).fetchAll(db)
//            }
//            return try type.fetchAll(db)
//        }
//    }
    
    func retrieveObjects<T: FetchableRecord & TableRecord>(ofType type: T.Type,
                                                           filter: String? = nil,
                                                           arguments: [Any] = []) throws -> [T]
    {
        try dbQueue.read { db in
            if let filter
            {
                let statement = StatementArguments(arguments) ?? StatementArguments()
                return try T.filter(sql: filter,
                                    arguments: statement).fetchAll(db)
            }
            return try T.fetchAll(db)
        }
    }
    
//    func retrieveObjects<T: FetchableRecord & TableRecord>(
//        ofType type: T.Type,
//        sql: String? = nil,
//        arguments: [Any] = []
//    ) -> [T] {
//
//        return (try? dbQueue.read { db in
//            if let sql {
//                if let grdbArgs = StatementArguments(arguments.compactMap { $0 as? DatabaseValueConvertible })
//                {
//                    return try T.fetchAll(db, sql: "SELECT * FROM \(T.databaseTableName) WHERE \(sql)",
//                                          arguments: grdbArgs)
//                }
//            }
//            return try T.fetchAll(db)
//        }) ?? []
//    }
//    
//    func fetch3<T: FetchableRecord & PersistableRecord>(
//        _ type: T.Type,
//        filter: DBFilter? = nil
//    ) throws -> [T]
//    {
//        try dbQueue.read { db in
//            guard let filter else { return try T.fetchAll(db) }
//            return try T.fetchAll(db, sql: "SELECT * FROM \(T.databaseTableName) WHERE \(filter.sql)",
//                                  arguments: StatementArguments(filter.arguments))
//        }
//    }
//    
//    func fetchNew<T: FetchableRecord & PersistableRecord>(
//        type: T.Type,
//        filters: [SQLExpression] = []
//    ) throws -> [T] {
//        try dbQueue.read { db in
//            guard !filters.isEmpty else {
//                return try T.fetchAll(db)
//            }
//            let combined = filters.dropFirst().reduce(filters[0]) { $0 || $1 }
//            return try T.filter(combined).fetchAll(db)
//        }
//    }
//    
    
}
struct DBFilter
{
    let sql: String
    let arguments: [DatabaseValueConvertible]
}


struct Filter
{
    fileprivate let expression: SQLExpression
    
    init(expression: SQLExpression) {
        self.expression = expression
    }

    func and(_ other: Filter) -> Filter {
        Filter(expression: expression && other.expression)
    }
    
    func or(_ other: Filter) -> Filter {
        Filter(expression: expression || other.expression)
    }
    
    func not() -> Filter {
        Filter(expression: !expression)
    }
}

//struct Filter
//{
//    // Internal GRDB expression, hidden from outside
//    fileprivate let expression: SQLExpression
//    
//    init(expression: SQLExpression) {
//        self.expression = expression
//    }
//    
//    func and(_ other: SQLExpression) -> Filter {
//        Filter(expression: expression && other)
//    }
//    
//    func or(_ other: SQLExpression) -> Filter {
//        Filter(expression: expression || other)
//    }
//    
//    func not() -> Filter {
//        Filter(expression: !expression)
//    }
//}

extension Filter
{
    enum _Coins
    {
        static var holdings: SQLExpression
        {
            return Column(Coin.CodingKeys.marketCapRank) > 0.0
        }
        
        static var topRank: SQLExpression {
            return Column(Coin.CodingKeys.marketCapRank) <= 3
        }
    }
}

//
//

