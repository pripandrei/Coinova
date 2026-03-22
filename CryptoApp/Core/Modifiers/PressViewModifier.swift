//
//  PressViewModifier.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/22/26.
//

import SwiftUI

struct PressViewModifier: ViewModifier
{
    let scaleFactor: CGFloat
    @State private var pressInProgress: Bool = false
    
    func body(content: Content) -> some View
    {
        content
//            .opacity(pressInProgress ? 0.8 : 1.0)
            .scaleEffect(pressInProgress ? scaleFactor : 1.0)
            .animation(.bouncy(duration: 0.3, extraBounce: 0.3),
                       value: pressInProgress)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in pressInProgress = true }
                    .onEnded { _ in pressInProgress = false }
            )
    }
}
