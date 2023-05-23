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
                updateNotification(category: category)
            } catch {
                guard let error = error as? BudgetError else { return }
                onError?(error)
            }
        }
    }
    
    private func updateNotification(category: AddTransactionViewData.Category) {
        let settings = Worker.shared.settings.get()
        guard let category = Worker.shared.category.getCategory(by: category.id) else { return }
        let transactions = Worker.shared.transaction.get(on: category.id, from: date, format: .monthYear)
        guard let budget = category.budgetsValue.first(where: { $0.date.asString(withDateFormat: .monthYear) == date.asString(withDateFormat: .monthYear) }) else { return }
        let total = budget.amount == 0 ? 1 : budget.amount
        let actual = transactions.map({ $0.amount }).reduce(0, +)
        let percent = (actual * 100) / total
        guard !hasWarning(budgetID: budget.id, settings: settings, total: total, actual: actual, percent: percent, name: category.name) else { return }
        guard !hasBreaking(budgetID: budget.id, settings: settings, total: total, actual: actual, name: category.name) else { return }
    }
    
    private func hasWarning(budgetID: UUID, settings: SettingsEntity, total: Double, actual: Double, percent: Double, name: String) -> Bool {
        if actual <= total, percent >= 70, !settings.currentWarningNotificationAppears.contains(budgetID) {
            NotificationCenter.shared.makeWarningExpenses(budgetID: budgetID, percent: percent, category: name, actual: actual, total: total)
            return true
        }
        return false
    }
    
    private func hasBreaking(budgetID: UUID, settings: SettingsEntity, total: Double, actual: Double, name: String) -> Bool {
        if actual > total, !settings.currentBreakingNotificationAppears.contains(budgetID) {
            NotificationCenter.shared.makeWarningBreakExpenses(budgetID: budgetID, category: name)
            return true
        }
        return false
    }
}
