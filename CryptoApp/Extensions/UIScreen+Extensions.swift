//
//  UIScreen+Extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 3/18/26.
//

import UIKit

extension UIScreen
{
    // App is portrait only, so safe to use
    //
    var width: CGFloat
    {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen.bounds.width ?? 0.0
    }
}
