//
//  SettingsRouter.swift
//  
//
//  Created by Rafael Santos on 27/03/23.
//

import SwiftUI
import Domain

public enum SettingsRoutes {
    case addTransactions
    case addCategory
    case pro
    case about
    case notification
    case customization
    case customAppIcon
}

public struct SettingsRouter {
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: SettingsRoutes) -> some View {
        switch routes {
        case .addTransactions: AnyView(factory.makeAddTransactionScreen(transaction: nil))
        case .addCategory: AnyView(factory.makeAddCategoryScreen(category: nil))
        case .pro: AnyView(factory.makeProScreen())
        case .about: AnyView(factory.makeAboutScreen())
        case .notification: AnyView(factory.makeNotificationScreen())
        case .customization: AnyView(factory.makeCustomizationScreen())
        case .customAppIcon: AnyView(factory.makeCustomAppIconScreen())
        }
    }
}

