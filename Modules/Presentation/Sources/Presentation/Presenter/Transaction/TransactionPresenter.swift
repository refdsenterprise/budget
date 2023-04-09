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
    var selectedPeriod: PeriodTransaction { get set }
    
    var totalAmount: Double { get set }
    var chartData: [(date: Date, value: Double)] { get set }
    var transactionsFiltred: [TransactionEntity] { get set }
    
    func string(_ string: Strings.Transaction) -> String
    func loadData()
    func remove(transaction: TransactionEntity, onError: ((BudgetError) -> Void)?)
}

public final class TransactionPresenter: TransactionPresenterProtocol {
    public var router: TransactionRouter
    @Published private var transactions: [TransactionEntity] = []
    
    @Published public var date: Date = Date() { didSet { loadData() } }
    @Published public var query: String = "" { didSet { loadSearchResults() } }
    @Published public var isFilterPerDate: Bool = true { didSet { loadData() } }
    @Published public var selectedPeriod: PeriodTransaction = .monthly { didSet { loadData() } }
    @Published public var isPresentedAddTransaction: Bool = false
    @Published public var isPresentedEditTransaction: Bool = false
    @Published public var alert: BudgetAlert = .init()
    @Published public var transaction: TransactionEntity?
    public var category: CategoryEntity?
    
    @Published public var totalAmount: Double = 0
    @Published public var chartData: [(date: Date, value: Double)] = []
    @Published public var transactionsFiltred: [TransactionEntity] = []
    
    public init(router: TransactionRouter, category: CategoryEntity? = nil, date: Date? = nil) {
        self.router = router
        self.category = category
        if let date = date { _date = Published(initialValue: date) }
    }
    
    public func string(_ string: Strings.Transaction) -> String {
        string.value
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
    
    public func loadData() {
        Task {
            await updateTransactions()
            await updateTransactionsFiltered()
            Task { await updateTotalAmount() }
            Task { await updateChartData() }
        }
    }
    
    public func loadSearchResults() {
        Task {
            await updateTransactionsFiltered()
            Task { await updateTotalAmount() }
            Task { await updateChartData() }
        }
    }
    
    @MainActor private func updateTransactions() async {
        let worker = Storage.shared.transaction
        if let category = category {
            transactions = isFilterPerDate ? worker.getTransactions(
                on: category,
                from: date,
                format: selectedPeriod.dateFormat
            ) : worker.getTransactions(on: category)
        } else {
            transactions = isFilterPerDate ? worker.getTransactions(
                from: date,
                format: selectedPeriod.dateFormat
            ) : worker.getAllTransactions()
        }
    }
    
    @MainActor private func updateTotalAmount() async {
        totalAmount = transactionsFiltred.map({
            $0.amount
        }).reduce(0, +)
    }
    
    @MainActor private func updateChartData() async {
        chartData = transactionsFiltred.map({
            (date: $0.date, value: $0.amount)
        })
    }
    
    @MainActor private func updateTransactionsFiltered() async {
        transactionsFiltred = transactions.filter({
            containsTransaction($0)
        })
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
