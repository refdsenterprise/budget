//
//  TabItem.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import Foundation
import SwiftUI
import RefdsUI

public enum TabItem: Int, CaseIterable {
    case category = 1
    case home = 2
    case transaction = 3
    case settings = 4
    
    public var title: String {
        switch self {
        case .category: return "Categorias"
        case .home: return "Início"
        case .transaction: return "Transações"
        case .settings: return "Ajustes"
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
