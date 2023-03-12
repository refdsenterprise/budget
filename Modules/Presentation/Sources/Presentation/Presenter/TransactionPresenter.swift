//
//  TransactionPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import Domain
import Data
import Resource
import UserInterface

public protocol TransactionPresenterProtocol: ObservableObject {
    var router: TransactionRouter { get }
    var date: Date { get set }
    var query: String { get set }
    var isFilterPerDate: Bool { get set }
    var isPresentedAddTransaction: Bool { get set }
    var isPresentedEditTransaction: Bool { get set }
    var alert: BudgetAlert { get set }
    var transaction: TransactionEntity? { get set }
    var category: CategoryEntity? { get }
    var selectedPeriodString: String { get set }
    var selectedPeriod: PeriodTransaction { get set }
    var totalAmount: Double { get }
    var chartData: [(date: Date, value: Double)] { get }
    var transactionsFiltred: [TransactionEntity] { get }
    
    func string(_ string: Strings.Transaction) -> String
    func loadData()
    func remove(transaction: TransactionEntity, onError: ((BudgetError) -> Void)?)
}

public final class TransactionPresenter: TransactionPresenterProtocol {
    public var router: TransactionRouter
    
    @Published public var date: Date = Date()
    @Published public var transactions: [TransactionEntity] = []
    @Published public var query: String = ""
    @Published public var isFilterPerDate: Bool = true { didSet { loadData() } }
    @Published public var isPresentedAddTransaction: Bool = false
    @Published public var isPresentedEditTransaction: Bool = false
    @Published public var alert: BudgetAlert = .init()
    @Published public var transaction: TransactionEntity?
    public var category: CategoryEntity?
    
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
        didSet { loadData() }
    }
    
    public var totalAmount: Double {
        transactions.filter({
            containsTransaction($0)
        }).map({ $0.amount }).reduce(0, +)
    }
    
    public var chartData: [(date: Date, value: Double)] {
        transactionsFiltred.map({
            (date: $0.date, value: $0.amount)
        })
    }
    
    public var transactionsFiltred: [TransactionEntity] {
        transactions.filter({ containsTransaction($0) })
    }
    
    public init(router: TransactionRouter, category: CategoryEntity? = nil, date: Date? = nil) {
        self.router = router
        self.category = category
        if let date = date { _date = Published(initialValue: date) }
    }
    
    public func string(_ string: Strings.Transaction) -> String {
        string.value
    }
    
    public func loadData() {
        let transaction = Storage.shared.transaction
        if let category = category {
            transactions = isFilterPerDate ? transaction.getTransactions(on: category, from: date, format: selectedPeriod.dateFormat) : transaction.getTransactions(on: category)
        } else {
            transactions = isFilterPerDate ? transaction.getTransactions(from: date, format: selectedPeriod.dateFormat) : transaction.getAllTransactions()
        }
    }
    
    public func remove(transaction: TransactionEntity, onError: ((BudgetError) -> Void)? = nil) {
        do {
            try Storage.shared.transaction.removeTransaction(transaction)
            loadData()
        } catch {
            guard let error = error as? BudgetError else { return }
            onError?(error)
        }
    }
    
    private func containsTransaction(_ transaction: TransactionEntity) -> Bool {
        guard !query.isEmpty else { return true }
        let query = query.stripingDiacritics.lowercased()
        let description = transaction.description.stripingDiacritics.lowercased().contains(query)
        let category = transaction.category?.name.stripingDiacritics.lowercased().contains(query) ?? false
        let amount = "\(transaction.amount)".lowercased().contains(query)
        let date = transaction.date.asString(withDateFormat: selectedPeriod.dateFormat).lowercased().contains(query)
        return description || category || amount || date
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
