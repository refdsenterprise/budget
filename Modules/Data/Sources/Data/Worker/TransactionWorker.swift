//
//  TransactionWorker.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsCore
import Domain
import CoreData

public final class TransactionWorker {
    public static let shared = TransactionWorker()
    private let database = Database.shared
    
    public func get() -> [TransactionEntity] {
        let request = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return (try? database.viewContext.fetch(request)) ?? []
    }
    
    public func get(in id: UUID) -> TransactionEntity? {
        let request = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        guard let transaction = try? database.viewContext.fetch(request).first else { return nil }
        return transaction
    }
    
    public func get(from date: Date = Date(), format: String.DateFormat = .monthYear) -> [TransactionEntity] {
        get().filter { transaction in
            let transactionDate = transaction.date.asString(withDateFormat: format)
            let currentDate = date.asString(withDateFormat: format)
            return transactionDate == currentDate
        }
    }
    
    public func get(on category: UUID) -> [TransactionEntity] {
        let request = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", category as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        guard let transactions = try? database.viewContext.fetch(request) else { return [] }
        return transactions
    }
    
    public func get(on category: UUID, from date: Date = Date(), format: String.DateFormat = .monthYear) -> [TransactionEntity] {
        get(on: category).filter { transaction in
            let transactionDate = transaction.date.asString(withDateFormat: format)
            let currentDate = date.asString(withDateFormat: format)
            return transactionDate == currentDate
        }
    }
    
    public func add(id: UUID, date: Date, message: String, category: UUID, amount: Double) throws {
        guard let transaction = get(in: id) else {
            let transaction = TransactionEntity(context: database.viewContext)
            transaction.id = id
            transaction.date = date.timestamp
            transaction.message = message
            transaction.category = category
            transaction.amount = amount
            try database.viewContext.save()
            return
        }
        transaction.id = id
        transaction.date = date.timestamp
        transaction.message = message
        transaction.category = category
        transaction.amount = amount
        try database.viewContext.save()
    }
    
    public func remove(id: UUID) throws {
        guard let transaction = get(in: id) else { throw BudgetError.notFoundTransaction }
        database.viewContext.delete(transaction)
        try database.viewContext.save()
    }
    
    public func replaceAllTransactions(_ data: Data?) {
        guard let data = data,
              let transactions = try? JSONDecoder().decode([TransactionIM].self, from: data) else {
            return
        }
        for transaction in transactions {
            try? add(id: transaction.id, date: transaction.date, message: transaction.description, category: transaction.categoryUUID, amount: transaction.amount)
        }
        print("transactions")
        transactions.forEach({ print($0) })
    }
    
    struct TransactionIM: Decodable {
        var amount: Double
        var categoryUUID: UUID
        var date: Date
        var id: UUID
        var description: String
    }
    
    public func getChartDataTransactions(
        from date: Date? = nil,
        period: PeriodItem? = nil
    ) -> [(date: Date, value: Double)] {
        if let date = date, let period = period {
            return get().filter({
                period == .week ? (period.containsWeek(originalDate: date, compareDate: $0.date.date)) : ($0.date.asString(withDateFormat: period.dateFormat) == date.asString(withDateFormat: period.dateFormat))
            }).map({ (date: $0.date.date, value: $0.amount) })
        } else {
            return get().map({ (date: $0.date.date, value: $0.amount) })
        }
    }
}
