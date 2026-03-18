//
//  NavigationButton.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/12/26.
//

import SwiftUI

struct NavigationButton: View
{
    let iconName: String
    private let buttonSize: CGSize = .init(width: 45, height: 45)
    
    var body: some View
    {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: buttonSize.width,
                   height: buttonSize.height)
            .background(
                Circle()
                    .fill(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.2),
                    radius: 10,
                    x: 0,
                    y: 0)
    }
}

#Preview {
    NavigationButton(iconName: "plus")
}
