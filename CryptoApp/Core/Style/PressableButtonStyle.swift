//
//  PressableButtonStyle.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/22/26.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle
{
    let scaleFactor: CGFloat
    
    func makeBody(configuration: Configuration) -> some View
    {
        let isPressed = configuration.isPressed
        
        configuration.label
//            .opacity(isPressed ? 0.8 : 1.0)
            .scaleEffect(isPressed ? scaleFactor : 1.0)
//            .animation(.spring(duration: 0.3),
            .animation(.bouncy(duration: 0.3, extraBounce: 0.3),
                       value: isPressed)
    }
}
