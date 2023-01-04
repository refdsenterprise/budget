//
//  CategoryPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import Foundation
import SwiftUI

final class CategoryPresenter: ObservableObject {
    static var instance: Self { Self() }
    
    @Published var document: DataDocument = .init()
    @Published var date: Date = Date()
    @Published var categories: [CategoryEntity] = []
    @Published var transactions: [TransactionEntity] = []
    @Published var query: String = ""
    @Published var isFilterPerDate = true
    
    func loadData() {
        let category = Storage.shared.category
        let transaction = Storage.shared.transaction
        categories = isFilterPerDate ? category.getCategories(from: date) : category.getAllCategories()
        transactions = isFilterPerDate ? transaction.getTransactions(from: date) : transaction.getAllTransactions()
        document.codable = categories.asString
    }
    
    func removeCategory(_ category: CategoryEntity) {
        try? Storage.shared.category.removeCategory(category)
        loadData()
    }
    
    func containsCategory(_ category: CategoryEntity) -> Bool {
        guard !query.isEmpty else { return true }
        let query = query.lowercased()
        let name = category.name.lowercased().contains(query)
        if let budget = category.budgets.first(where: {
            $0.date.asString(withDateFormat: "MM/yyyy") == date.asString(withDateFormat: "MM/yyyy")
        })?.amount, !isFilterPerDate {
            return name || "\(budget)".lowercased().contains(query)
        }
        return name
    }
    
    func getActualTransaction(by category: CategoryEntity) -> Double {
        getTransactions(by: category).map({ $0.amount }).reduce(0, +)
    }
    
    func getBudget(by category: CategoryEntity) -> BudgetEntity? {
        isFilterPerDate ?
        category.budgets.first(where: {
            $0.date.asString(withDateFormat: "MM/yyyy") == date.asString(withDateFormat: "MM/yyyy")
        }) : .init(amount: category.budgets.map({ $0.amount }).reduce(0, +) / Double(category.budgets.count))
    }
    
    func getTotalBudget() -> Double {
        let total = getCategoriesFiltred().flatMap({ $0.budgets }).map({ $0.amount }).reduce(0, +)
        return isFilterPerDate ? total : total / Double(categories.count)
    }
    
    func getTotalActual() -> Double {
        getCategoriesFiltred().map({
            getActualTransaction(by: $0)
        }).reduce(0, +)
    }
    
    func getCategoriesFiltred() -> [CategoryEntity] {
        categories.filter({ containsCategory($0) })
    }
    
    func getTransactions(by category: CategoryEntity) -> [TransactionEntity] {
        transactions.filter({ $0.category == category })
    }
}
