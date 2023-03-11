//
//  MainRouter.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import Domain
import UserInterface

public enum MainRoutes {
    case category
    case budget
    case transactions
}

public struct MainRouter {
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: MainRoutes) -> some View {
        switch routes {
        case .category: AnyView(factory.makeCategoryScreen())
        case .budget: AnyView(factory.makeBudgetScene())
        case .transactions: AnyView(factory.makeTransactionScene())
        }
    }
}
