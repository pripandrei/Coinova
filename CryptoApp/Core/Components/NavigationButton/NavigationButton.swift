//
//  NavigationButton.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/12/26.
//

import SwiftUI

struct NavigationButton: View
{
    @State var style: Style
    private let buttonSize: CGSize = .init(width: 45, height: 45)
    
    var body: some View
    {
        content
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .background()
            .clipShape(shape)
            .withGlassEffectIfAvailable()
            .shadow(color: Color.theme.accent.opacity(0.2),
                    radius: 10,
                    x: 0,
                    y: 0)
    }
}

//MARK: - view components
extension NavigationButton
{
    @ViewBuilder
    private var content: some View
    {
        switch style
        {
        case .icon(let string):
            Image(systemName: string)
                .frame(width: 45, height: 45)
        case .text(let string):
            Text(string)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
        }
    }
    
    private var shape: AnyShape
    {
        if case .icon = style {
            AnyShape(.circle)
        } else {
            AnyShape(.capsule)
        }
    }
}

//MARK: - style enum
extension NavigationButton
{
    enum Style: Equatable
    {
        case icon(String)
        case text(String)
    }
}

#Preview {
//    NavigationButton(style: .text("pluss type"))
    NavigationButton(style: .icon("plus"))
}

//
//ToolbarItem(placement: .automatic) {
//    Button {
//
//    } label: {
//        Image(systemName: "xmark")
//    }
//    .frame(width: 100, height: 100)
//    .glassEffect(.regular.interactive())
//    .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 0)
//}
//.sharedBackgroundVisibility(.hidden)


