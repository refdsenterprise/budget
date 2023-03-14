//
//  AddCategoryRouter.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import Domain

public enum AddCategoryRoutes {
    case addBudget(((BudgetEntity) -> Void)?)
}

public struct AddCategoryRouter {
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: AddCategoryRoutes) -> some View {
        switch routes {
        case .addBudget(let newBudget): AnyView(factory.makeAddBudgetScreen(newBudget: newBudget))
        }
    }
}
