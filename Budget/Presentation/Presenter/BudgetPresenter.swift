//
//  BudgetPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 01/01/23.
//

import SwiftUI

final class BudgetPresenter: ObservableObject {
    static var instance: Self { Self() }
    
    @Published var date: Date = Date()
    @Published var categories: [CategoryEntity] = []
    @Published var transactions: [TransactionEntity] = []
    @Published var isFilterPerDate = true
    
    func loadData() {
        let category = Storage.shared.category
        let transaction = Storage.shared.transaction
        categories = isFilterPerDate ? category.getCategories(from: date) : category.getAllCategories()
        transactions = isFilterPerDate ? transaction.getTransactions(from: date) : transaction.getAllTransactions()
    }
    
    func getTransactions(by category: CategoryEntity) -> [TransactionEntity] {
        transactions.filter({ $0.category == category })
    }
    
    func getActualTransaction(by category: CategoryEntity) -> Double {
        getTransactions(by: category).map({ $0.amount }).reduce(0, +)
    }
    
    func getBudget(by category: CategoryEntity) -> BudgetEntity? {
        isFilterPerDate ?
        category.budgets.first(where: {
            $0.date.asString(withDateFormat: "MM/yyyy") == date.asString(withDateFormat: "MM/yyyy")
        }) :
        //.init(amount: category.budgets.map({ $0.amount }).reduce(0, +) / Double(category.budgets.count))
            .init(amount: category.budgets.map({ $0.amount }).reduce(0, +))
    }
    
    func getTotalBudget() -> Double {
        let total = categories.flatMap({ $0.budgets }).map({ $0.amount }).reduce(0, +)
        //return isFilterPerDate ? total : total / Double(categories.count)
        return total
    }
    
    func getTotalActual() -> Double {
        categories.map({
            return getActualTransaction(by: $0)
        }).reduce(0, +)
    }
    
    func getActualColor(actual: Double, budget: Double) -> Color {
        let accent = budget - actual > 0
        let secondary = budget - actual == 0
        return accent ? .accentColor : secondary ? .secondary : .pink
    }
    
    func getChartData() -> [(label: String, data: [(category: String, value: Double)])] {
        return [
            (label: "Budget", data: getBudgetData()),
            (label: "Atual", data: getActualData())
        ]
    }
    
    func getBudgetData() -> [(category: String, value: Double)] {
        categories.map({
            (category: $0.name.capitalized, value: getBudget(by: $0)?.amount ?? 0)
        })
    }
    
    func getActualData() -> [(category: String, value: Double)] {
        categories.map({
            (category: $0.name.capitalized, value: getActualTransaction(by: $0))
        })
    }
}
