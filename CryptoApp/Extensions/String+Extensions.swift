//
//  String+Extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/15/26.
//

import Foundation
import CryptoKit

extension String
{
    var sha256: String {
        let hash = SHA256.hash(data: Data(self.utf8))
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func toSafeFilename() -> String
    {
        return self.sha256
    }
    
    var lastWord: String {
        return self.components(separatedBy: " ").last ?? ""
    }
}
