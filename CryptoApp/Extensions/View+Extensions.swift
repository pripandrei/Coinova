//
//  View+Extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/18/26.
//

import SwiftUI
import LoaderUI

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
    
    func withTruncationEffect(_ lineLimit: Int) -> some View
    {
        self.modifier(TruncationEffectViewModifier(lineLimit: lineLimit))
    }
    
    func loadingIndicator(_ isLoading: Bool, size: CGFloat = 50.0) -> some View
    {
        ZStack
        {
            self
            
            if isLoading
            {
//                CircleStrokeSpin()
                BallScaleRippleMultiple()
                    .frame(width: size, height: size)
                    .foregroundStyle(.link)
            }
        }
    }
}
