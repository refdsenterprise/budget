//
//  TransactionPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import Domain
import Data

public final class TransactionPresenter: ObservableObject {
    public var router: TransactionRouter
    
    @Published public var date: Date = Date()
    @Published public var transactions: [TransactionEntity] = []
    @Published public var query: String = ""
    @Published public var isFilterPerDate = true
    @Published public var document: DataDocument = .init()
    @Published public var selectedPeriodString: String = PeriodTransaction.monthly.value {
        didSet {
            for period in PeriodTransaction.allCases {
                if period.value == selectedPeriodString {
                    selectedPeriod = period
                }
            }
        }
    }
    
    @Published public var selectedPeriod: PeriodTransaction = .monthly {
        didSet {
            loadData()
        }
    }
    
    private var category: CategoryEntity?
    
    public init(router: TransactionRouter, category: CategoryEntity? = nil, date: Date? = nil) {
        self.router = router
        self.category = category
        if let date = date {
            _date = Published(initialValue: date)
        }
    }
    
    public func loadData() {
        let transaction = Storage.shared.transaction
        if let category = category {
            transactions = isFilterPerDate ? transaction.getTransactions(on: category, from: date, format: selectedPeriod.dateFormat) : transaction.getTransactions(on: category)
        } else {
            transactions = isFilterPerDate ? transaction.getTransactions(from: date, format: selectedPeriod.dateFormat) : transaction.getAllTransactions()
        }
        document.codable = transactions.asString
    }
    
    public func getTransactionsFiltred() -> [TransactionEntity] {
        transactions.filter({ containsTransaction($0) })
    }
    
    public func getTotalAmount() -> Double {
        transactions.filter({ containsTransaction($0) }).map({ $0.amount }).reduce(0, +)
    }
    
    public func removeTransaction(_ transaction: TransactionEntity) {
        try? Storage.shared.transaction.removeTransaction(transaction)
        loadData()
    }
    
    public func getChartData() -> [(date: Date, value: Double)]{
        getTransactionsFiltred().map({ (date: $0.date, value: $0.amount) })
    }
    
    public func containsTransaction(_ transaction: TransactionEntity) -> Bool {
        guard !query.isEmpty else { return true }
        let query = query.stripingDiacritics.lowercased()
        let description = transaction.description.stripingDiacritics.lowercased().contains(query)
        let category = transaction.category?.name.stripingDiacritics.lowercased().contains(query) ?? false
        let amount = "\(transaction.amount)".lowercased().contains(query)
        let date = transaction.date.asString(withDateFormat: selectedPeriod.dateFormat).lowercased().contains(query)
        return description || category || amount || date
    }
    
    @available(iOS 15.0, *)
    public func csvStringWithTransactions() -> URL? {
        let header: String = "Data,Categoria,Valor,Descrição\n"
        let footer: String = "Total,\(getTotalAmount().formatted(.currency(code: "BRL")).replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: ",", with: "."))\n"
        var body: String = ""
        for transaction in transactions {
            body += "\(transaction.date.asString(withDateFormat: .custom("dd/MM/yyyy - HH:mm"))),\(transaction.category?.name ?? ""),\(transaction.amount.formatted(.currency(code: "BRL")).replacingOccurrences(of: ".", with: " ").replacingOccurrences(of: ",", with: ".")),\(transaction.description.replacingOccurrences(of: ",", with: ""))\n"
        }
        let csv = header + body + footer
        if let jsonData = csv.data(using: .utf8),
           let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("Transações - \(date.asString(withDateFormat: selectedPeriod.dateFormatFile).replacingOccurrences(of: "/", with: " de ")).csv")
            do {
                try jsonData.write(to: pathWithFileName)
                return pathWithFileName
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

public enum PeriodTransaction: CaseIterable {
    case daily
    //case weekly
    case monthly
    case yearly
    
    public var value: String {
        switch self {
        case .daily: return "diário"
        //case .weekly: return "semanal"
        case .monthly: return "mensal"
        case .yearly: return "anual"
        }
    }
    
    public var dateFormat: String.DateFormat {
        switch self {
        case .daily: return .dayMonthYear
        //case .weekly: return "EEE/MM/yyyy"
        case .monthly: return .monthYear
        case .yearly: return .custom("yyyy")
        }
    }
    
    public var dateFormatFile: String.DateFormat {
        switch self {
        case .daily: return .custom("dd/MMMM/yyyy")
        case .monthly: return .custom("MMMM/yyyy")
        case .yearly: return .custom("yyyy")
        }
    }
    
    public static var values: [String] {
        PeriodTransaction.allCases.map { $0.value }
    }
}
