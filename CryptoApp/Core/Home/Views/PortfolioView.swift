//
//  ProfileView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/21/26.
//


import SwiftUI

struct PortfolioView: View
{
    @Environment(HomeViewModel.self) var homeVM
    @Environment(\.dismiss) var dismiss
    
    var body: some View
    {
        NavigationStack
        {
            @Bindable var homeVM = homeVM
            
            VStack(alignment: .leading)
            {
                Text("Edit Portfolio")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.theme.accent)
                    .padding(.leading, 25)
                    .padding(.vertical, 20)
                
                SearchBarView(searchQuery: $homeVM.searchQuery)
            
                Spacer()
            }
            .toolbar
            {
                if #available(iOS 26.0, *)
                {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationButton(style: .icon("xmark")) {
                            dismiss.callAsFunction()
                        }
                    }
                    .sharedBackgroundVisibility(.hidden)
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationButton(style: .text("Save")) {
                            dismiss.callAsFunction()
                        }
                    }
                    .sharedBackgroundVisibility(.hidden)
                } else {
                    
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationButton(style: .icon("xmark")) {
                            dismiss.callAsFunction()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationButton(style: .text("Save")) {
                            dismiss.callAsFunction()
                        }
                    }
                }
            }
        }
    }
}


//MARK: View components
extension PortfolioView
{
    
}


#Preview {
    let vm = HomeViewModel()
    return PortfolioView()
        .environment(vm)
}
