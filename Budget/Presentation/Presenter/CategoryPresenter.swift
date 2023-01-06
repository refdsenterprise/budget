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
    
    func removeCategory(_ category: CategoryEntity) throws {
        guard !Storage.shared.transaction.getAllTransactions().contains(where: { $0.categoryUUID == category.id }) else { throw BudgetError.cantDeleteCategory }
        isFilterPerDate ? removeBudgetInsideCategory(category) : removeAllCategory(category)
        loadData()
    }
    
    func removeAllCategory(_ category: CategoryEntity) {
        try? Storage.shared.category.removeCategory(category)
    }
    
    func removeBudgetInsideCategory(_ category: CategoryEntity) {
        try? Storage.shared.category.editCategory(
            category,
            name: category.name,
            color: category.color,
            budgets: category.budgets.filter({
                $0.date.asString(withDateFormat: "MM/yyyy") != date.asString(withDateFormat: "MM/yyyy")
                
            })
        )
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
        let total = getCategoriesFiltred().map({ getBudget(by: $0)?.amount ?? 0 }).reduce(0, +)
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
    
    func getDateFromLastCategoriesByCurrentDate() -> Date? {
        guard isFilterPerDate, categories.isEmpty else { return nil }
        guard let previousDate = Calendar.current.date(byAdding: .month, value: -1, to: date)?.asString(withDateFormat: "MM/yyyy") else { return nil }
        guard Storage.shared.category.getAllCategories().firstIndex(where: { category in
            return category.budgets.map({ $0.date.asString(withDateFormat: "MM/yyyy") }).contains(previousDate)
        }) != nil else { return nil }
        return Calendar.current.date(byAdding: .month, value: -1, to: date)
    }
    
    func duplicateCategories(from previousDate: Date) {
        guard isFilterPerDate, categories.isEmpty else { return }
        let categories = Storage.shared.category.getCategories(from: previousDate)
        categories.forEach { category in
            if let lastBudget = category.budgets.first(where: { $0.date.asString(withDateFormat: "MM/yyyy") == previousDate.asString(withDateFormat: "MM/yyyy") }) {
                try? Storage.shared.category.editCategory(
                    category,
                    name: category.name,
                    color: category.color,
                    budgets: category.budgets + [BudgetEntity(date: date, amount: lastBudget.amount)]
                )
            }
        }
        loadData()
    }
    
    func getDifferencePercent(budget: Double, actual: Double, hasPlaces: Bool = false) -> String {
        var percent = (actual * 100) / budget
        percent = percent > 100 ? (100 - percent) : percent
        if !hasPlaces {
            let percentInteger = Int(percent)
            return String(format: "%02d", percentInteger) + "%"
        } else {
            return String(format: "%02.02f", percent).replacingOccurrences(of: ".", with: ",") + "%"
        }
    }
}
