//
//  Image.swift
//  
//
//  Created by Rafael Santos on 18/03/23.
//

import Foundation
import SwiftUI

public enum ResourceImage {
    case proIcon
    case categoriesOnboarding
    case transactionsOnboarding
    
    public var image: Image {
        switch self {
        case .proIcon: return Image("pro-icon", bundle: .module)
        case .categoriesOnboarding: return Image("categories-onboarding", bundle: .module)
        case .transactionsOnboarding: return Image("transactions-onboarding", bundle: .module)
        }
    }
}

