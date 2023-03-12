//
//  FactoryProtocol.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import Foundation
import Domain
import UserInterface
import SwiftUI

public protocol FactoryProtocol {
    func makeCategoryScreen() -> any View
    func makeTransactionScreen(category: CategoryEntity?, date: Date?) -> any View
    func makeAddCategoryScreen(category: CategoryEntity?) -> any View
    func makeAddBudgetScreen(newBudget: ((BudgetEntity) -> Void)?) -> any View
    func makeBudgetScene() -> any View
    func makeAddTransactionScreen(transaction: TransactionEntity?) -> any View
}
