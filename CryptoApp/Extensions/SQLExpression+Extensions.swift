//
//  SQLExpression+Extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/28/26.
//

import GRDB

extension SQLExpression
{
    func and(_ value: Self) -> Self
    {
        return value && self
    }
    
    func or(_ value: Self) -> Self
    {
        return value || self
    }
}
