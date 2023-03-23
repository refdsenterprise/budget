//
//  Image.swift
//  
//
//  Created by Rafael Santos on 18/03/23.
//

import Foundation
import SwiftUI

public enum ResourceImage {
    case categoriesOnboarding
    case transactionsOnboarding
    
    public var image: Image {
        switch self {
        case .categoriesOnboarding: return Image("categories-onboarding", bundle: .module)
        case .transactionsOnboarding: return Image("transactions-onboarding", bundle: .module)
        }
    }
}

