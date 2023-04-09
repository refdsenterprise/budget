//
//  FactoryProtocol.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import Domain
import SwiftUI

public protocol FactoryProtocol {
    func makeCategoryScreen() -> any View
    func makeTransactionScreen(category: CategoryEntity?, date: Date?) -> any View
    func makeAddCategoryScreen(category: CategoryEntity?) -> any View
    func makeAddBudgetScreen(newBudget: ((BudgetEntity) -> Void)?) -> any View
    func makeBudgetScreen() -> any View
    func makeAddTransactionScreen(transaction: TransactionEntity?) -> any View
    func makeSettingsScreen() -> any View
    func makeProScreen() -> any View
    func makeAboutScreen() -> any View
    func makeNotificationScreen() -> any View
    func makeCustomizationScreen() -> any View
}
