//
//  NavButtonAnimation.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/12/26.
//

import SwiftUI

struct InfoButtonAnimation: View
{
    var animationInitiated: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.theme.accent, lineWidth: 2)
                .opacity(animationInitiated ? 0.0 : 1.0)
                .scaleEffect(animationInitiated ? 1.5 : 0.8)
                .animation(animationInitiated ? .easeOut(duration: 0.8) : nil,
                           value: animationInitiated)
            
        }
    }
}
