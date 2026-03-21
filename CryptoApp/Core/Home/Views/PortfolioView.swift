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
            
            VStack
            {
                SearchBarView(searchQuery: $homeVM.searchQuery)
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    closeButton
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    saveButton
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
        Button {
            dismiss.callAsFunction()
        } label: {
            Image(systemName: "xmark")
        }
    }
    
    private var saveButton: some View
    {
        Button {
            
            dismiss.callAsFunction()
        } label: {
            Text("Save")
        }

    }
}


#Preview {
//    TestView()
    let vm = HomeViewModel()
    return PortfolioView()
        .environment(vm)
}
