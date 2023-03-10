//
//  CategoryPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import Foundation
import SwiftUI
import Domain
import Data

public final class CategoryPresenter: ObservableObject {
    public static var instance: Self { Self() }
    
    @Published public var document: DataDocument = .init()
    @Published public var date: Date = Date()
    @Published public var categories: [CategoryEntity] = []
    @Published public var transactions: [TransactionEntity] = []
    @Published public var query: String = ""
    @Published public var isFilterPerDate = true
    
    public func loadData() {
        let category = Storage.shared.category
        let transaction = Storage.shared.transaction
        categories = isFilterPerDate ? category.getCategories(from: date) : category.getAllCategories()
        transactions = isFilterPerDate ? transaction.getTransactions(from: date) : transaction.getAllTransactions()
        document.codable = categories.asString
    }
    
    public func removeCategory(_ category: CategoryEntity) throws {
        guard !Storage.shared.transaction.getAllTransactions().contains(where: { $0.categoryUUID == category.id }) else { throw BudgetError.cantDeleteCategory }
        isFilterPerDate ? removeBudgetInsideCategory(category) : removeAllCategory(category)
        loadData()
    }
    
    public func removeAllCategory(_ category: CategoryEntity) {
        try? Storage.shared.category.removeCategory(category)
    }
    
    public func removeBudgetInsideCategory(_ category: CategoryEntity) {
        try? Storage.shared.category.editCategory(
            category,
            name: category.name,
            color: category.color,
            budgets: category.budgets.filter({
                $0.date.asString(withDateFormat: .monthYear) != date.asString(withDateFormat: .monthYear)
            })
        )
    }
    
    public func containsCategory(_ category: CategoryEntity) -> Bool {
        guard !query.isEmpty else { return true }
        let query = query.stripingDiacritics.lowercased()
        let name = category.name.stripingDiacritics.lowercased().contains(query)
        if let budget = category.budgets.first(where: {
            $0.date.asString(withDateFormat: .monthYear) == date.asString(withDateFormat: .monthYear)
        })?.amount, !isFilterPerDate {
            return name || "\(budget)".stripingDiacritics.lowercased().contains(query)
        }
        return name
    }
    
    public func getActualTransaction(by category: CategoryEntity) -> Double {
        getTransactions(by: category).map({ $0.amount }).reduce(0, +)
    }
    
    public func getBudget(by category: CategoryEntity) -> BudgetEntity? {
        isFilterPerDate ?
        category.budgets.first(where: {
            $0.date.asString(withDateFormat: .monthYear) == date.asString(withDateFormat: .monthYear)
        }) : .init(amount: category.budgets.map({ $0.amount }).reduce(0, +))
    }
    
    public func getTotalBudget() -> Double {
        return getCategoriesFiltred().map({ getBudget(by: $0)?.amount ?? 0 }).reduce(0, +)
    }
    
    public func getTotalActual() -> Double {
        getCategoriesFiltred().map({
            getActualTransaction(by: $0)
        }).reduce(0, +)
    }
    
    public func getCategoriesFiltred() -> [CategoryEntity] {
        categories.filter({ containsCategory($0) })
    }
    
    public func getTransactions(by category: CategoryEntity) -> [TransactionEntity] {
        transactions.filter({ $0.category == category })
    }
    
    public func getDateFromLastCategoriesByCurrentDate() -> Date? {
        guard isFilterPerDate, categories.isEmpty else { return nil }
        guard let previousDate = Calendar.current.date(byAdding: .month, value: -1, to: date)?.asString(withDateFormat: .monthYear) else { return nil }
        guard Storage.shared.category.getAllCategories().firstIndex(where: { category in
            return category.budgets.map({ $0.date.asString(withDateFormat: .monthYear) }).contains(previousDate)
        }) != nil else { return nil }
        return Calendar.current.date(byAdding: .month, value: -1, to: date)
    }
    
    public func duplicateCategories(from previousDate: Date) {
        guard isFilterPerDate, categories.isEmpty else { return }
        let categories = Storage.shared.category.getCategories(from: previousDate)
        categories.forEach { category in
            if let lastBudget = category.budgets.first(where: { $0.date.asString(withDateFormat: .monthYear) == previousDate.asString(withDateFormat: .monthYear) }) {
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
    
    @available(iOS 15.0, *)
    public func csvStringWithTransactions() -> URL? {
        let header: String = "Data,Categoria,Valor,Descrição\n"
        let footer: String = "\nBudget Total,\(getTotalActual().formatted(.currency(code: "BRL")).replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: ",", with: "."))\n"
        var body: String = ""
        for transaction in transactions.sorted(by: { ($0.category?.name ?? "") < ($1.category?.name ?? "") }) {
            body += "\(transaction.date.asString(withDateFormat: .custom("dd/MM/yyyy - HH:mm"))),\(transaction.category?.name ?? ""),\(transaction.amount.formatted(.currency(code: "BRL")).replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: ",", with: ".")),\(transaction.description.replacingOccurrences(of: ",", with: ""))\n"
        }
        let csv = header + body + footer
        if let jsonData = csv.data(using: .utf8),
           let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("Transações.csv")
            do {
                try jsonData.write(to: pathWithFileName)
                return pathWithFileName
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public func getDifferencePercent(budget: Double, actual: Double, hasPlaces: Bool = false) -> String {
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
