//
//  UIApplication+extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/18/26.
//

import SwiftUI

extension UIApplication
{
    func endEditing()
    {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil,
                   from: nil,
                   for: nil)
    }
}
