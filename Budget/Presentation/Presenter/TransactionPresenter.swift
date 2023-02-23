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
    @Published var selectedPeriodString: String = PeriodTransaction.monthly.value {
        didSet {
            for period in PeriodTransaction.allCases {
                if period.value == selectedPeriodString {
                    selectedPeriod = period
                }
            }
        }
    }
    
    @Published var selectedPeriod: PeriodTransaction = .monthly {
        didSet {
            loadData()
        }
    }
    
    private var category: CategoryEntity?
    
    init(category: CategoryEntity? = nil, date: Date? = nil) {
        self.category = category
        if let date = date {
            _date = Published(initialValue: date)
        }
    }
    
    func loadData() {
        let transaction = Storage.shared.transaction
        if let category = category {
            transactions = isFilterPerDate ? transaction.getTransactions(on: category, from: date, format: selectedPeriod.dateFormat) : transaction.getTransactions(on: category)
        } else {
            transactions = isFilterPerDate ? transaction.getTransactions(from: date, format: selectedPeriod.dateFormat) : transaction.getAllTransactions()
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
    
    func getChartData() -> [(date: Date, value: Double)]{
        getTransactionsFiltred().map({ (date: $0.date, value: $0.amount) })
    }
    
    func containsTransaction(_ transaction: TransactionEntity) -> Bool {
        guard !query.isEmpty else { return true }
        let query = query.stripingDiacritics.lowercased()
        let description = transaction.description.stripingDiacritics.lowercased().contains(query)
        let category = transaction.category?.name.stripingDiacritics.lowercased().contains(query) ?? false
        let amount = "\(transaction.amount)".lowercased().contains(query)
        let date = transaction.date.asString(withDateFormat: selectedPeriod.dateFormat).lowercased().contains(query)
        return description || category || amount || date
    }
}

enum PeriodTransaction: CaseIterable {
    case daily
    //case weekly
    case monthly
    case yearly
    
    var value: String {
        switch self {
        case .daily: return "diário"
        //case .weekly: return "semanal"
        case .monthly: return "mensal"
        case .yearly: return "anual"
        }
    }
    
    var dateFormat: String {
        switch self {
        case .daily: return "dd/MM/yyyy"
        //case .weekly: return "EEE/MM/yyyy"
        case .monthly: return "MM/yyyy"
        case .yearly: return "yyyy"
        }
    }
    
    static var values: [String] {
        PeriodTransaction.allCases.map { $0.value }
    }
}
