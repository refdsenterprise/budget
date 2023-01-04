//
//  TransactionPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI

final class TransactionPresenter: ObservableObject {
    static var instance: Self { Self() }
    
    @Published var date: Date = Date()
    @Published var transactions: [TransactionEntity] = []
    @Published var query: String = ""
    @Published var isFilterPerDate = true
    @Published var document: DataDocument = .init()
    private var category: CategoryEntity?
    
    init(category: CategoryEntity? = nil) {
        self.category = category
    }
    
    func loadData() {
        let transaction = Storage.shared.transaction
        if let category = category {
            transactions = (isFilterPerDate ? transaction.getTransactions(on: category, from: date) : transaction.getTransactions(on: category)).reversed()
        } else {
            transactions = (isFilterPerDate ? transaction.getTransactions(from: date) : transaction.getAllTransactions()).reversed()
        }
        document.codable = transactions.asString
    }
    
    func getTransactionsFiltred() -> [TransactionEntity] {
        transactions.filter({ containsTransaction($0) })
    }
    
    func getTotalAmount() -> Double {
        transactions.filter({ containsTransaction($0) }).map({ $0.amount }).reduce(0, +)
    }
    
    func removeTransaction(_ transaction: TransactionEntity) {
        try? Storage.shared.transaction.removeTransaction(transaction)
        loadData()
    }
    
    func containsTransaction(_ transaction: TransactionEntity) -> Bool {
        guard !query.isEmpty else { return true }
        let query = query.lowercased()
        let description = transaction.description.lowercased().contains(query)
        let category = transaction.category.name.lowercased().contains(query)
        let amount = "\(transaction.amount)".lowercased().contains(query)
        let date = transaction.date.asString(withDateFormat: "MM/yyyy").lowercased().contains(query)
        return description || category || amount || date
    }
}
