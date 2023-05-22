//
//  FactoryProtocol.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import Domain
import SwiftUI

public protocol FactoryProtocol {
    func makeSceneScreen() -> any View
    func makeCategoryScreen(isPresentedAddCategory: Bool, isPresentedAddBudget: Bool) -> any View
    func makeTransactionScreen(category: UUID?, date: Date?, isPresentedAddTransaction: Bool) -> any View
    func makeAddCategoryScreen(category: UUID?) -> any View
    func makeAddBudgetScreen(newBudget: ((AddBudgetViewData) -> Void)?, category: UUID?, budget: UUID?) -> any View
    func makeBudgetScreen() -> any View
    func makeAddTransactionScreen(transaction: UUID?) -> any View
    func makeSettingsScreen() -> any View
    func makeProScreen() -> any View
    func makeAboutScreen() -> any View
    func makeNotificationScreen() -> any View
    func makeCustomizationScreen() -> any View
}
