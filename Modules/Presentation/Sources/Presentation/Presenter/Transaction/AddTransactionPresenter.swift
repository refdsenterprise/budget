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
    var viewData: AddTransactionViewData { get set }
    var date: Date { get set }
    var amount: Double { get set }
    var alert: AlertItem { get set }
    var buttonForegroundColor: Color { get }
    var transaction: UUID? { get }
    var isStarted: Bool { get }
    
    func loadData()
    func string(_ string: Strings.AddTransaction) -> String
    func save(onSuccess: (() -> Void)?, onError: ((BudgetError) -> Void)?)
    func start(transaction: UUID?) async
}

public final class AddTransactionPresenter: AddTransactionPresenterProtocol {
    public var router: AddTransactionRouter
    @Published public var viewData: AddTransactionViewData = .init()
    @Published public var date: Date = .current { didSet { loadData() } }
    @Published public var amount: Double = 0 { didSet { loadData() } }
    @Published public var alert: AlertItem = .init()
    public var transaction: UUID?
    public var isStarted: Bool = false
    
    private var canAddNewTransaction: Bool {
        return viewData.amount > 0 && viewData.category != nil && !viewData.message.isEmpty
    }
    
    public var buttonForegroundColor: Color {
        return canAddNewTransaction ? .accentColor : .secondary
    }
    
    public init(router: AddTransactionRouter, transaction: UUID? = nil) {
        self.router = router
        self.transaction = transaction
    }
    
    public func start(transaction: UUID?) async {
        if let id = transaction,
            let transaction = Worker.shared.transaction.get(in: id),
            let category = Worker.shared.category.getCategory(by: transaction.category) {
            let totalActual = Worker.shared.transaction.get(from: transaction.date.date, format: .monthYear).map({ $0.amount }).reduce(0, +)
            let totalBudget = category.budgetsValue.first(where: {
                $0.date.asString(withDateFormat: .monthYear) == transaction.date.asString(withDateFormat: .monthYear)
            })?.amount ?? 0
            let categories = Worker.shared.category.getCategories(from: transaction.date.date).map({
                let totalActual = Worker.shared.transaction.get(from: transaction.date.date, format: .monthYear).map({ $0.amount }).reduce(0, +)
                let totalBudget = $0.budgetsValue.first(where: {
                    $0.date.asString(withDateFormat: .monthYear) == transaction.date.asString(withDateFormat: .monthYear)
                })?.amount ?? 0
                return AddTransactionViewData.Category(
                    id: $0.id,
                    color: Color(hex: $0.color),
                    name: $0.name,
                    remaning: totalBudget - totalActual
                )
            })
            Task { @MainActor in
                viewData = .init(
                    id: transaction.id,
                    amount: transaction.amount,
                    message: transaction.message,
                    category: .init(
                        id: category.id,
                        color: Color(hex: category.color),
                        name: category.name,
                        remaning: totalBudget - totalActual
                    ),
                    categories: categories,
                    date: transaction.date.date
                )
                date = transaction.date.date
                amount = transaction.amount
            }
        } else {
            let categories = Worker.shared.category.getCategories(from: viewData.date).map({
                let totalActual = Worker.shared.transaction.get(from: viewData.date, format: .monthYear).map({ $0.amount }).reduce(0, +)
                let totalBudget = $0.budgetsValue.first(where: {
                    $0.date.date.asString(withDateFormat: .monthYear) == viewData.date.asString(withDateFormat: .monthYear)
                })?.amount ?? 0
                return AddTransactionViewData.Category(
                    id: $0.id,
                    color: Color(hex: $0.color),
                    name: $0.name,
                    remaning: totalBudget - totalActual
                )
            })
            Task { @MainActor in
                viewData.categories = categories
                viewData.category = categories.first
            }
        }
        isStarted = true
    }
    
    public func loadData() {
        Task {
            await updateCategories()
            await updateCategory()
        }
    }
    
    @MainActor private func updateCategories() async {
        let categories = Worker.shared.category.getCategories(from: viewData.date).map({
            let totalActual = Worker.shared.transaction.get(on: $0.id, from: viewData.date, format: .monthYear).map({ $0.amount }).reduce(0, +) + viewData.amount
            let totalBudget = Worker.shared.category.getBudget(on: $0.id, from: viewData.date)?.amount ?? 0
            return AddTransactionViewData.Category(
                id: $0.id,
                color: Color(hex: $0.color),
                name: $0.name,
                remaning: totalBudget - totalActual
            )
        })
        
        viewData.date = date
        viewData.amount = amount
        viewData.categories = categories
    }
    
    @MainActor private func updateCategory() async {
        if viewData.category == nil {
            viewData.category = viewData.categories?.first
        } else if let category = viewData.category,
                  !(viewData.categories?.map({ $0.id }).contains(category.id) ?? false) {
            viewData.category = viewData.categories?.first
        }
    }
    
    public func string(_ string: Strings.AddTransaction) -> String {
        string.value
    }
    
    public func save(onSuccess: (() -> Void)? = nil, onError: ((BudgetError) -> Void)? = nil) {
        if canAddNewTransaction {
            guard let category = viewData.category else {
                onError?(.notFoundCategory)
                return
            }
            
            do {
                try Worker.shared.transaction.add(
                    id: viewData.id,
                    date: viewData.date,
                    message: viewData.message,
                    category: category.id,
                    amount: viewData.amount
                )
                onSuccess?()
                checkWarning()
            } catch {
                guard let error = error as? BudgetError else { return }
                onError?(error)
            }
        }
    }
    
    private func checkWarning() {
//        let database = Database.shared
//        var notification: NotificationEntity = database.get(on: .notification) ?? .init()
//        let categories = Worker.shared.category.getCategories(from: date, format: .monthYear)
//        let transactions = Worker.shared.transaction.getTransactions(from: date, format: .monthYear)
//        let date = date.asString(withDateFormat: .monthYear)
//        var totalBudget = categories.map { category in
//            category.budgetsValue.filter {
//                $0.date.asString(withDateFormat: .monthYear) == date
//            }.first?.amount ?? 0
//        }.reduce(0, +)
//        totalBudget = totalBudget == 0 ? 1 : totalBudget
//        let totalActual = transactions.map { $0.amount }.reduce(0, +)
//        let percent = (totalActual * 100) / totalBudget
//
//        if totalActual <= totalBudget, percent >= 70, notification.warningExpensesDate?.asString(withDateFormat: .monthYear) != date {
//            notification.warningExpensesDate = .current
//            NotificationCenter.shared.makeWarningExpenses(percent: percent, actual: totalActual, total: totalBudget)
//        } else if totalActual > totalBudget, notification.breakingExpensesDate?.asString(withDateFormat: .monthYear) != date {
//            notification.breakingExpensesDate = .current
//            NotificationCenter.shared.makeWarningBreakExpenses()
//        } else if let category = category {
//            let budgetCategory = category.budgetsValue.first(where: { $0.date.asString(withDateFormat: .monthYear) == date })?.amount ?? 1
//            let actualCategory = transactions.filter { $0.categoryUUID == category.id }.map { $0.amount }.reduce(0, +)
//            let percent = (actualCategory * 100) / budgetCategory
//
//            if actualCategory <= budgetCategory, percent >= 70, notification.warningExpensesCategoriesDate[category.id]?.asString(withDateFormat: .monthYear) != date {
//                notification.warningExpensesCategoriesDate[category.id] = .current
//                NotificationCenter.shared.makeWarningExpenses(percent: percent, category: category.name, actual: actualCategory, total: budgetCategory)
//            } else if actualCategory > budgetCategory, notification.breakingExpensesCategoriesDate[category.id]?.asString(withDateFormat: .monthYear) != date {
//                notification.breakingExpensesCategoriesDate[category.id] = .current
//                NotificationCenter.shared.makeWarningBreakExpenses(category: category.name)
//            }
//        }
    }
}
