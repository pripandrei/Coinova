//
//  GlassEffectModifier.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/22/26.
//

import SwiftUI

struct GlassEffectModifier: ViewModifier
{
    func body(content: Content) -> some View
    {
        if #available(iOS 26.0, *)
        {
            content.glassEffect(.regular.interactive())
        } else {
            content.modifier(PressViewModifier(scaleFactor: 1.2))
        }
    }
}
