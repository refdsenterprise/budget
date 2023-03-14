//
//  AddTransactionRouter.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import Domain

public enum AddTransactionRoutes {
    case addCategory
}

public struct AddTransactionRouter {
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: AddTransactionRoutes) -> some View {
        switch routes {
        case .addCategory: AnyView(factory.makeAddCategoryScreen(category: nil))
        }
    }
}
