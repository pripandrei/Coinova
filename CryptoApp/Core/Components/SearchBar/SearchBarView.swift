//
//  SearchBarView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/18/26.
//

import SwiftUI

struct SearchBarView: View
{
    private let prompt = "Search for a coin"
    @State private var searchQuery: String = ""
    
    var body: some View
    {
        HStack
        {
            Image(systemName: "magnifyingglass")
                .fontWeight(.medium)
                .foregroundStyle(searchQuery.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
            
            TextField(
                prompt,
                text: $searchQuery,
                prompt: Text(prompt).fontWeight(.regular)
            )
            .foregroundStyle(Color.theme.accent)
            .fontWeight(.medium)
        }
        .padding(13)
        .padding(.horizontal, 5)
        .background(Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .shadow(color: Color.theme.accent.opacity(0.2),
                radius: 10,
                x: 0,
                y: 0)
        .overlay(alignment: .trailing) {
            clearTextButton
        }
        .padding(.horizontal, 20)
    }
    
    private var clearTextButton: some View
    {
        Circle()
            .fill(Color.theme.secondaryText)
            .overlay {
                Image(systemName: "xmark")
                    .scaleEffect(1.3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.theme.background)
            }
            .scaleEffect(0.5)
            .padding(.trailing, 5)
            .opacity(searchQuery.isEmpty ? 0 : 1)
            .animation(.bouncy, value: searchQuery)
            .onTapGesture {
                searchQuery = ""
            }
    }
}

#Preview {
    SearchBarView()
}
