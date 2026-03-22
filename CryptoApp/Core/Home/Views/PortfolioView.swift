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
                    .padding(.leading, 25)
                    .padding(.vertical, 20)
                
                SearchBarView(searchQuery: $homeVM.searchQuery)
//                    .padding(.vertical, 30)
            
                Spacer()
            }
//            .navigationTitle("Edit Portfolio")
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
    private var closeButton: some View
    {
//            Button {
//                dismiss.callAsFunction()
//            } label: {
//                Image(systemName: "xmark")
//            }
        Image(systemName: "xmark")
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    private var saveButton: some View
    {
//        Button {
//            
//            dismiss.callAsFunction()
//        } label: {
//            Text("Save")
//        }
        Text("Save")
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
}


#Preview {
    let vm = HomeViewModel()
    return PortfolioView()
        .environment(vm)
}
