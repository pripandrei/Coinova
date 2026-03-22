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
    
    func withGlassEffectIfAvailable() -> some View
    {
        self.modifier(GlassEffectModifier())
    }
    
    func withPressableStyle(_ scaleFactor: CGFloat = 1.2) -> some View
    {
        self.buttonStyle(PressableButtonStyle(scaleFactor: scaleFactor))
    }
    
    func withPressableScale() -> some View
    {
        self.modifier(PressViewModifier(scaleFactor: 1.2))
    }
    
    
    @ViewBuilder
    func applyIf(_ condition: Bool,
                 transform: (Self) -> some View) -> some View
    {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func pressEffectIfUnavailable() -> some View
    {
        if #available(iOS 26, *)
        {
            return AnyView(self)
        } else {
            return AnyView(self.modifier(PressViewModifier(scaleFactor: 1.4)))
        }
    }
}
