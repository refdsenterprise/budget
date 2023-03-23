//
//  AddTransactionPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import Domain
import Data
import Resource

public protocol AddTransactionPresenterProtocol: ObservableObject {
    var router: AddTransactionRouter { get }
    
    var date: Date { get set }
    var description: String { get set }
    var amount: Double { get set }
    var category: CategoryEntity? { get set }
    var transaction: TransactionEntity? { get }
    var alert: BudgetAlert { get set }
    var buttonForegroundColor: Color { get }
    
    func loadData()
    func loadData(newDate: Date)
    func string(_ string: Strings.AddTransaction) -> String
    func getBudget(on category: CategoryEntity) -> BudgetEntity?
    func getCategories() -> [CategoryEntity]
    func save(onSuccess: (() -> Void)?, onError: ((BudgetError) -> Void)?)
}

public final class AddTransactionPresenter: AddTransactionPresenterProtocol {
    public var router: AddTransactionRouter
    
    @Published public var date: Date
    @Published public var description: String
    @Published public var amount: Double
    @Published public var category: CategoryEntity?
    @Published public var transaction: TransactionEntity?
    @Published public var alert: BudgetAlert = .init()
    
    private var canAddNewTransaction: Bool {
        return amount > 0 && category != nil && !description.isEmpty
    }
    
    public var buttonForegroundColor: Color {
        return canAddNewTransaction ? .accentColor : .secondary
    }
    
    public init(router: AddTransactionRouter, transaction: TransactionEntity? = nil) {
        self.router = router
        self.transaction = transaction
        self.date = transaction?.date ?? Date()
        self.description = transaction?.description ?? ""
        self.amount = transaction?.amount ?? 0
        if let category = transaction?.category {
            self.category = category
        } else {
            self.category = Storage.shared.category.getCategories(from: .current).first
        }
    }
    
    public func loadData() {
        if category == nil {
            category = Storage.shared.category.getCategories(from: date).first
        }
    }
    
    public func loadData(newDate: Date) {
        let categories = Storage.shared.category.getCategories(from: newDate)
        
        if category == nil {
            self.category = categories.first
        } else if let category = category, !categories.map({ $0.id }).contains(category.id) {
            self.category = categories.first
        }
    }
    
    public func string(_ string: Strings.AddTransaction) -> String {
        string.value
    }
    
    public func getBudget(on category: CategoryEntity) -> BudgetEntity? {
        category.budgets.first { budget in
            budget.date.asString(withDateFormat: .monthYear) == date.asString(withDateFormat: .monthYear)
        }
    }
    
    public func getCategories() -> [CategoryEntity] {
        Storage.shared.category.getCategories(from: date)
    }
    
    public func save(onSuccess: (() -> Void)? = nil, onError: ((BudgetError) -> Void)? = nil) {
        if canAddNewTransaction {
            if transaction != nil { editTransaction(onSuccess: onSuccess, onError: onError) }
            else { addTransaction(onSuccess: onSuccess, onError: onError) }
        }
    }
    
    private func addTransaction(onSuccess: (() -> Void)? = nil, onError: ((BudgetError) -> Void)? = nil) {
        guard let category = category else { onError?(.notFoundCategory); return }
        do {
            try Storage.shared.transaction.addTransaction(
                date: date,
                description: description,
                category: category,
                amount: amount
            )
            onSuccess?()
            checkWarning()
        } catch {
            guard let error = error as? BudgetError else { return }
            onError?(error)
        }
    }
    
    private func editTransaction(onSuccess: (() -> Void)? = nil, onError: ((BudgetError) -> Void)? = nil) {
        guard let category = category, let transaction = transaction else { onError?(.notFoundTransaction); return }
        do {
            try Storage.shared.transaction.editTransaction(
                transaction,
                date: date,
                description: description,
                category: category,
                amount: amount
            )
            onSuccess?()
            checkWarning()
        } catch {
            guard let error = error as? BudgetError else { return }
            onError?(error)
        }
    }
    
    private func checkWarning() {
        let database = BudgetDatabase.shared
        var notification: NotificationEntity = database.get(on: .notification) ?? .init()
        let categories = Storage.shared.category.getCategories(from: date, format: .monthYear)
        let transactions = Storage.shared.transaction.getTransactions(from: date, format: .monthYear)
        let date = date.asString(withDateFormat: .monthYear)
        var totalBudget = categories.map { category in
            category.budgets.filter {
                $0.date.asString(withDateFormat: .monthYear) == date
            }.first?.amount ?? 0
        }.reduce(0, +)
        totalBudget = totalBudget == 0 ? 1 : totalBudget
        let totalActual = transactions.map { $0.amount }.reduce(0, +)
        let percent = (totalActual * 100) / totalBudget
        
        if totalActual <= totalBudget, percent >= 70, notification.warningExpensesDate?.asString(withDateFormat: .monthYear) != date {
            notification.warningExpensesDate = .current
            NotificationCenter.shared.makeWarningExpenses(percent: percent, actual: totalActual, total: totalBudget)
        } else if totalActual > totalBudget, notification.breakingExpensesDate?.asString(withDateFormat: .monthYear) != date {
            notification.breakingExpensesDate = .current
            NotificationCenter.shared.makeWarningBreakExpenses()
        } else if let category = category {
            let budgetCategory = category.budgets.first(where: { $0.date.asString(withDateFormat: .monthYear) == date })?.amount ?? 1
            let actualCategory = transactions.filter { $0.categoryUUID == category.id }.map { $0.amount }.reduce(0, +)
            let percent = (actualCategory * 100) / budgetCategory
            
            if actualCategory <= budgetCategory, percent >= 70, notification.warningExpensesCategoriesDate[category.id]?.asString(withDateFormat: .monthYear) != date {
                notification.warningExpensesCategoriesDate[category.id] = .current
                NotificationCenter.shared.makeWarningExpenses(percent: percent, category: category.name, actual: actualCategory, total: budgetCategory)
            } else if actualCategory > budgetCategory, notification.breakingExpensesCategoriesDate[category.id]?.asString(withDateFormat: .monthYear) != date {
                notification.breakingExpensesCategoriesDate[category.id] = .current
                NotificationCenter.shared.makeWarningBreakExpenses(category: category.name)
            }
        }
        
        database.set(on: .notification, value: notification)
    }
}
