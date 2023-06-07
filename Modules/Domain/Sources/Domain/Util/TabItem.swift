//
//  TabItem.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import Foundation
import SwiftUI
import RefdsUI
import Resource

public enum TabItem: Int, CaseIterable {
    case category = 1
    case home = 2
    case transaction = 3
    case settings = 4
    
    public var title: String {
        switch self {
        case .category: return Strings.UserInterface.categories.value
        case .home: return Strings.UserInterface.home.value
        case .transaction: return Strings.UserInterface.transactions.value
        case .settings: return Strings.UserInterface.settings.value
        }
    }
    
    public var image: Image {
        switch self {
        case .category: return Image(systemName: RefdsIconSymbol.squareStack3DForwardDottedlineFill.rawValue)
        case .home: return Image(systemName: RefdsIconSymbol.houseFill.rawValue)
        case .transaction: return Image(systemName: RefdsIconSymbol.listBulletRectangleFill.rawValue)
        case .settings: return Image(systemName: RefdsIconSymbol.gear.rawValue)
        }
    }
}
