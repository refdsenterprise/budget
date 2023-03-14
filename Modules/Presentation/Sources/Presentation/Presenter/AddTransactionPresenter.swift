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
        return canAddNewTransaction ? (category?.color ?? .accentColor) : .secondary
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
        category = Storage.shared.category.getCategories(from: date).first
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
        } catch {
            guard let error = error as? BudgetError else { return }
            onError?(error)
        }
    }
}
