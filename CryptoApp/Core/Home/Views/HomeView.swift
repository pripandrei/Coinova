//
//  ContentView.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/12/26.
//

import SwiftUI

struct HomeView: View
{
    @State private var currentNavigationStatus: NavigationStatus = .livePrices
    
    var body: some View
    {
        ZStack
        {
            Color.theme.background
                .ignoresSafeArea()
         
            VStack
            {
                header
                Spacer()
            }
        }
    }
}

//MARK: - View components
extension HomeView
{
    private var header: some View
    {
        HStack
        {
            NavigationButton(iconName: currentNavigationStatus == .livePrices ? "info" : "plus")
                .background(
                    InfoButtonAnimation(animationInitiated: shouldAnimateInfoButton())
                )
                .onTapGesture {
                    
                }
            
            Spacer()
            
            Text(currentNavigationStatus.title)
                .font(.title3)
                .fontWeight(.semibold)
                .animation(nil)
            
            Spacer()
            
            NavigationButton(iconName: "chevron.right")
                .rotationEffect(.degrees(currentNavigationStatus == .livePrices ? 0 : 180))
                .onTapGesture
            {
                withAnimation(.linear(duration: 0.3))
                {
                    self.currentNavigationStatus = currentNavigationStatus == .livePrices ? .portfolio : .livePrices
                }
            }
           
        }
        .padding(.horizontal, 30)
    }
}

//MARK: - Execute functions
extension HomeView
{
    private func shouldAnimateInfoButton() -> Bool
    {
        return currentNavigationStatus == .livePrices ? false : true
    }
}

extension HomeView
{
    enum NavigationStatus
    {
        case livePrices
        case portfolio
        
        var title: String
        {
            switch self
            {
            case .livePrices: return "Live Prices"
            case .portfolio: return "Portfolio"
            }
        }
    }
}

#Preview {
    HomeView()
//    NavigationButton(iconName: "info")
}

