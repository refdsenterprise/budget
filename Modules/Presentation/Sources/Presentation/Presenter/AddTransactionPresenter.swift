//
//  AddTransactionPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import Domain
import Data

public final class AddTransactionPresenter: ObservableObject {
    @Published public var date: Date
    @Published public var description: String
    @Published public var amount: Double
    @Published public var category: CategoryEntity? = Storage.shared.category.getCategories(from: Date.current).first
    @Published public var selectionCategory: Int = 0
    public var transaction: TransactionEntity?
    
    public init(transaction: TransactionEntity?) {
        self.transaction = transaction
        self.date = transaction?.date ?? Date()
        self.description = transaction?.description ?? ""
        self.amount = transaction?.amount ?? 0
        if let category = transaction?.category {
            self.category = category
        }
    }
    
    public var canAddNewTransaction: Bool {
        return amount > 0 && category != nil && !description.isEmpty
    }
    
    public var buttonBackgroundColor: Color {
        return canAddNewTransaction ? .accentColor.opacity(0.2) : .secondary.opacity(0.2)
    }
    
    public var buttonForegroundColor: Color {
        return canAddNewTransaction ? (category?.color ?? .accentColor) : .secondary
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
    
    public func getCategories() -> [CategoryEntity] {
        Storage.shared.category.getCategories(from: date)
    }
}
