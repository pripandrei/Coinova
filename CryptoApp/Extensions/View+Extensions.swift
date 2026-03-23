//
//  View+Extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/18/26.
//

import SwiftUI

extension View
{
    func removePredictiveSuggestions() -> some View
    {
        return self
            .keyboardType(.alphabet)
            .autocorrectionDisabled(true)
    }
    
    func withPressableStyle(_ scaleFactor: CGFloat = 1.2) -> some View
    {
        self.buttonStyle(PressableButtonStyle(scaleFactor: scaleFactor))
    }
}
