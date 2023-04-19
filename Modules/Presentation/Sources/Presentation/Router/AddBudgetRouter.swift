//
//  AddBudgetRouter.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import SwiftUI
import Domain

public enum AddBudgetRoutes {
    case addCategory
}

public struct AddBudgetRouter {
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: AddBudgetRoutes) -> some View {
        switch routes {
        case .addCategory: AnyView(factory.makeAddCategoryScreen(category: nil))
        }
    }
}
