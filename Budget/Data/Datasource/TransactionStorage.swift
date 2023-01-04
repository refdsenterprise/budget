//
//  TransactionStorage.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI

final class TransactionStorage {
    static let shared = TransactionStorage()
    @AppStorage("transactions") private var transactions = [TransactionEntity]()
    
    func getAllTransactions() -> [TransactionEntity] { transactions }
    
    func getTransactions(
        from date: Date = Date(),
        format: String = "MM/yyyy"
    ) -> [TransactionEntity] {
        return transactions.filter { transaction in
            let transactionDate = transaction.date.asString(withDateFormat: format)
            let filterDate = date.asString(withDateFormat: format)
            return transactionDate == filterDate
        }
    }
    
    func getTransactions(on category: CategoryEntity) -> [TransactionEntity] {
        transactions.filter({ $0.category == category })
    }
    
    func getTransactions(
        on category: CategoryEntity,
        from date: Date = Date(),
        format: String = "MM/yyyy"
    ) -> [TransactionEntity] {
        return transactions.filter { transaction in
            let transactionDate = transaction.date.asString(withDateFormat: format)
            let filterDate = date.asString(withDateFormat: format)
            return transactionDate == filterDate && category == transaction.category
        }
    }
    
    func addTransaction(
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
            category: category,
            amount: amount
        ))
    }
    
    func editTransaction(
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
        transactions[index].category = category
        transactions[index].amount = amount
    }
    
    func removeTransaction(_ current: TransactionEntity) throws {
        guard let index = transactions.firstIndex(where: {
            $0 == current
        }) else { throw BudgetError.notFoundTransaction }
        transactions.remove(at: index)
    }
    
    func replaceAllTransactions(_ data: Data?) {
        guard let data = data,
              let transactions = try? JSONDecoder().decode([TransactionEntity].self, from: data) else {
            return
        }
        self.transactions = transactions
    }
}
