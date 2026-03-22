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
            .shadow(color: Color.theme.accent.opacity(0.2),
                    radius: 10,
                    x: 0,
                    y: 0)
//            .onAppear {
//                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
//                    withAnimation(.linear(duration: 1.0)) {
//                        if case .icon(let symbol) = style {
//                            style = symbol == "info" ? .icon("plus") : .icon("info")
//                        }
//                    }
//                }
//            }
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





//
//
//struct NavigationButton: View
//{
//    enum ContentStyle: Equatable
//    {
//        case icon(String)
//        case text(String)
//    }
//    
//    let style: ContentStyle
//    
//    var body: some View {
//        content
//            .padding(.horizontal, 12)
//            .padding(.vertical, 12)
//            .background(.blue)
//            .clipShape(clipShape)
//    }
//    
//    @ViewBuilder
//    var content: some View
//    {
//        switch style {
//        case .icon(let name):
//            Image(systemName: name)
//        case .text(let title):
//            Text(title)
//        }
//    }
//    
//    var clipShape: AnyShape {
//        if case .icon = style {
//            AnyShape(Circle())
//        } else {
//            AnyShape(Capsule())
//        }
//    }
//}
