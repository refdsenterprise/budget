//
//  TransactionRouter.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import Domain

public enum TransactionRoutes {
    case addTransaction(UUID?)
}

public struct TransactionRouter {
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: TransactionRoutes) -> some View {
        switch routes {
        case .addTransaction(let transaction): AnyView(factory.makeAddTransactionScreen(transaction: transaction))
        }
    }
}

