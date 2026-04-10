//
//  Untitled.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/10/26.
//

import Foundation

#if DEBUG || DEV

//MARK: - Decoding helper when decode fails

struct DecodingDebugger
{
    static func decode<T>(block: () throws -> T)
    {
        do {
            let value = try block()
            print("✅ Decoding succeeded: \n \(value)")
        } catch let DecodingError.keyNotFound(key, context) {
            print("❌ Missing key:", key.stringValue)
            print("Path: ", context.codingPath.map { $0.stringValue })
        } catch let DecodingError.typeMismatch(type, context) {
            print("❌ Type mismatch - expected: ", type)
            print("Path: ", context.codingPath.map { $0.stringValue })
            print("Debug: ", context.debugDescription)
        } catch let DecodingError.valueNotFound(type, context) {
            print("❌ Null/missing value - expected: ", type)
            print("Path: ", context.codingPath.map { $0.stringValue })
        } catch let DecodingError.dataCorrupted(context) {
            print("❌ Corrupted: ", context.debugDescription)
        } catch {
            print("❌ Other error: ", error)
        }
    }
    
    static func printRawJSON(from data: Data)
    {
        if let json = String(data: data, encoding: .utf8)
        {
            print("📦 Raw JSON:\n\(json)")
        } else {
            print("❌ Could not read JSON as UTF-8")
        }
    }
}
#endif
