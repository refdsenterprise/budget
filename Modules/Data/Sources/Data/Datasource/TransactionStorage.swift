//
//  TransactionStorage.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsCore
import Domain
import WidgetKit
 
public final class TransactionStorage {
    public static let shared = TransactionStorage()
    private var transactions: [TransactionEntity] {
        get {
            let userDefaults = UserDefaults(suiteName: "group.budget.3dd8df9f-624a-42d4-9a5c-088d0a0f01eb")
            if let transactionsData = userDefaults?.data(forKey: "transactions"),
               let decoded: [TransactionEntity] = transactionsData.asModel() {
                return decoded
            }
            return []
        }
        
        set {
            let userDefaults = UserDefaults(suiteName: "group.budget.3dd8df9f-624a-42d4-9a5c-088d0a0f01eb")
            userDefaults?.set(newValue.asData, forKey: "transactions")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    public func getAllTransactions() -> [TransactionEntity] { transactions }
    
    public func getTransactions(from date: Date = Date(), format: String.DateFormat = .monthYear) -> [TransactionEntity] {
        return transactions.filter { transaction in
            let transactionDate = transaction.date.asString(withDateFormat: format)
            let filterDate = date.asString(withDateFormat: format)
            return transactionDate == filterDate
        }
    }
    
    public func getTransactions(on category: CategoryEntity) -> [TransactionEntity] {
        transactions.filter({ $0.category == category })
    }
    
    public func getTransactions(
        on category: CategoryEntity,
        from date: Date = Date(),
        format: String.DateFormat = .monthYear
    ) -> [TransactionEntity] {
        return transactions.filter { transaction in
            let transactionDate = transaction.date.asString(withDateFormat: format)
            let filterDate = date.asString(withDateFormat: format)
            return transactionDate == filterDate && category == transaction.category
        }
    }
    
    public func addTransaction(
        date: Date = Date(),
        description: String,
        category: CategoryEntity,
        amount: Double
    ) throws {
        guard transactions.contains(where: {
            $0.date == date &&
            $0.description == description &&
            $0.amount == amount &&
            $0.category == category
        }) == false else { throw BudgetError.existingTransaction }
        transactions.append(.init(
            date: date,
            description: description,
            categoryUUID: category.id,
            amount: amount
        ))
        transactions.sort(by: { $0.date > $1.date })
    }
    
    public func editTransaction(
        _ current: TransactionEntity,
        date: Date = Date(),
        description: String,
        category: CategoryEntity,
        amount: Double
    ) throws {
        guard let index = transactions.firstIndex(where: {
            $0 == current
        }) else { throw BudgetError.notFoundTransaction }
        transactions[index].date = date
        transactions[index].description = description
        transactions[index].categoryUUID = category.id
        transactions[index].amount = amount
        transactions.sort(by: { $0.date > $1.date })
    }
    
    public func removeTransaction(_ current: TransactionEntity) throws {
        guard let index = transactions.firstIndex(where: {
            $0 == current
        }) else { throw BudgetError.notFoundTransaction }
        transactions.remove(at: index)
    }
    
    public func replaceAllTransactions(_ data: Data?) {
        guard let data = data,
              let transactions = try? JSONDecoder().decode([TransactionEntity].self, from: data) else {
            return
        }
        self.transactions = transactions
        self.transactions.sort(by: { $0.date > $1.date })
    }
    
    public func getChartDataTransactions(
        from date: Date? = nil,
        period: PeriodEntity? = nil
    ) -> [(date: Date, value: Double)] {
        if let date = date, let period = period {
            return getAllTransactions().filter({
                period == .week ? (period.containsWeek(originalDate: date, compareDate: $0.date)) : ($0.date.asString(withDateFormat: period.dateFormat) == date.asString(withDateFormat: period.dateFormat))
            }).map({ (date: $0.date, value: $0.amount) })
        } else {
            return getAllTransactions().map({ (date: $0.date, value: $0.amount) })
        }
    }
}
