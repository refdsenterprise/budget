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
import Resource

public protocol CategoryPresenterProtocol: ObservableObject {
    var router: CategoryRouter { get set }
    var viewData: CategoryViewData { get }
    
    var date: Date { get set }
    var query: String { get set }
    var isFilterPerDate: Bool { get set }
    var isPresentedAddCategory: Bool { get set }
    var isPresentedEditCategory: Bool { get set }
    var alert: AlertItem { get set }
    var category: UUID? { get set }
    
    func string(_ string: Strings.Category) -> String
    
    func loadData()
    func remove(_ category: CategoryViewData.Budget) async
}

public final class CategoryPresenter: CategoryPresenterProtocol {
    @Published public var router: CategoryRouter
    @Published public var viewData: CategoryViewData = .init()
    
    @Published public var date: Date = Date() { didSet { loadData() } }
    @Published public var query: String = "" { didSet { loadData() } }
    @Published public var isFilterPerDate: Bool = true { didSet { loadData() } }
    @Published public var isPresentedAddCategory: Bool = false
    @Published public var isPresentedEditCategory: Bool = false
    @Published public var alert: AlertItem = .init()
    @Published public var category: UUID?
    
    private var categories: [CategoryEntity] = []
    private var transactions: [TransactionEntity] = []
    private var categoriesFiltered: [CategoryEntity] = []
    
    public init(router: CategoryRouter) {
        self.router = router
    }
    
    public func string(_ string: Strings.Category) -> String {
        string.value
    }
    
    public func loadData() {
        Task {
            await updateCategories()
            await udpdateCategoriesFiltered()
            Task { await updateViewDataBudget() }
            Task { await updateViewDataValue() }
        }
    }
    
    @MainActor private func updateCategories() async {
        let categoryWorker = Worker.shared.category
        let transactionWorker = Worker.shared.transaction
        categories = isFilterPerDate ? categoryWorker.getCategories(from: date) : categoryWorker.getAllCategories()
        transactions = isFilterPerDate ? transactionWorker.get(from: date) : transactionWorker.get()
    }
    
    @MainActor private func udpdateCategoriesFiltered() async {
        categoriesFiltered = categories.filter({
            containsCategory($0)
        })
    }
    
    @MainActor private func updateViewDataBudget() async {
        viewData.budgets = categoriesFiltered.map {
            let budget = getBudgetAmount(by: $0) ?? 0
            let percent = getPercent(on: $0)
            let amountTransactions = getTransactions(by: $0).count
            return CategoryViewData.Budget(
                id: $0.id,
                color: Color(hex: $0.color),
                name: $0.name,
                percent: percent,
                amountTransactions: amountTransactions,
                budget: budget
            )
        }
    }
    
    @MainActor private func updateViewDataValue() async {
        let totalBudget = categoriesFiltered.map({ getBudgetAmount(by: $0) ?? 0 }).reduce(0, +)
        let totalActual = categoriesFiltered.map({ getTransactionAmount(by: $0) }).reduce(0, +)
        viewData.value = CategoryViewData.Value(
            totalActual: totalBudget,
            totalBudget: totalActual
        )
    }
    
    private func getBudgetAmount(by category: CategoryEntity) -> Double? {
        isFilterPerDate ?
        category.budgetsValue.first(where: {
            $0.date.asString(withDateFormat: .monthYear) == date.asString(withDateFormat: .monthYear)
        })?.amount : category.budgetsValue.map({ $0.amount }).reduce(0, +)
    }
    
    private func getPercent(on category: CategoryEntity) -> String {
        var budget = getBudgetAmount(by: category) ?? 1
        budget = budget == 0 ? 1 : budget
        let transactions = getTransactionAmount(by: category)
        var percent = (transactions * 100) / budget
        percent = percent > 100 ? (100 - percent) : percent
        return String(format: "%02.02f", percent).replacingOccurrences(of: ".", with: ",") + "%"
    }
    
    private func getTransactions(by category: CategoryEntity) -> [TransactionEntity] {
        transactions.filter({ $0.category == category.id })
    }
    
    @MainActor public func remove(_ category: CategoryViewData.Budget) async {
        guard !Worker.shared.transaction.get().contains(where: {
            $0.category == category.id
        }) else {
            alert = .init(error: .cantDeleteCategory)
            return
        }
        
        await isFilterPerDate ? removeBudgetInsideCategory(id: category.id) : removeAllCategory(id: category.id)
        loadData()
    }
    
    @MainActor private func removeAllCategory(id: UUID) async {
        try? Worker.shared.category.removeCategory(id: id)
    }
    
    @MainActor private func removeBudgetInsideCategory(id: UUID) async {
        guard let category = Worker.shared.category.getCategory(by: id) else { return }
        guard let budget = category.budgetsValue.filter({
            $0.date.asString(withDateFormat: .monthYear) != date.asString(withDateFormat: .monthYear)
        }).first else {
            await removeAllCategory(id: id)
            return
        }
        
        try? Worker.shared.category.removeBudget(id: budget.id)
        try? Worker.shared.category.addCategory(
            id: category.id,
            name: category.name,
            color: Color(hex: category.color),
            budgets: category.budgets.filter({ $0 != budget.id })
        )
    }
    
    private func containsCategory(_ category: CategoryEntity) -> Bool {
        guard !query.isEmpty else { return true }
        let query = query.stripingDiacritics.lowercased()
        let name = category.name.stripingDiacritics.lowercased().contains(query)
        return name
    }
    
    private func getTransactionAmount(by category: CategoryEntity) -> Double {
        getTransactions(by: category).map({ $0.amount }).reduce(0, +)
    }
}
