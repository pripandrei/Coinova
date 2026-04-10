//
//  TruncationEffectViewModifier.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/10/26.
//

import SwiftUI

struct TruncationEffectViewModifier: ViewModifier
{
    let lineLimit: Int
    
    @State private var showFullDescription: Bool = false
    @State private var descriptionSizeChanged: Bool = false
    
    @State private var fullHeight: CGFloat = 0
    @State private var limitedHeight: CGFloat = 0.0
    
    func body(content: Content) -> some View
    {
        VStack(alignment: .leading, spacing: 10)
        {
                content
                    .onGeometryChange(for: CGFloat.self, of: { geo in
                        geo.size.height
                    }, action: { newValue in
                        fullHeight = newValue
                    })
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
                    .overlay(alignment: .topLeading) {
                        if showFullDescription {
                            content
                                .lineLimit(nil)
                        } else {
                            content
                                .lineLimit(lineLimit)
                                .onGeometryChange(for: CGFloat.self, of: { geo in
                                    geo.size.height
                                }, action: { newValue in
                                    limitedHeight = newValue
                                })
                        }
                    }
                    .frame(maxHeight: showFullDescription ? fullHeight : limitedHeight,
                           alignment: .top)
                    .clipped()

            if fullHeight > limitedHeight
            {
                Button {
                    descriptionSizeChanged.toggle()
                    withAnimation(.easeOut(duration: 0.3)) {
                        showFullDescription.toggle()
                    }
                } label: {
                    Text(descriptionSizeChanged ? "Read less..." : "Read more...")
                        .font(.callout)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
