//
//  BudgetRouter.swift
//  
//
//  Created by Rafael Santos on 12/03/23.
//

import SwiftUI
import Domain

public enum BudgetRoutes {
    case transactions(UUID?, Date)
}

public struct BudgetRouter {
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: BudgetRoutes) -> some View {
        switch routes {
        case .transactions(let category, let date): AnyView(factory.makeTransactionScreen(category: category, date: date))
        }
    }
}

