//
//  ToolbarContent+Extensions.swift
//  CryptoApp
//
//  Created by Andrei Pripa on 4/10/26.
//

import SwiftUI

extension ToolbarContent
{
    func hideToolbarInteractionIfNeeded() -> some ToolbarContent
    {
        if #available(iOS 26, *)
        {
            return self.sharedBackgroundVisibility(.hidden)
        } else {
            return self
        }
    }
}
