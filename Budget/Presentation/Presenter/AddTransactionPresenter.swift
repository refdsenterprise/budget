//
//  AddTransactionPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI

final class AddTransactionPresenter: ObservableObject {
    @Published var date: Date
    @Published var description: String
    @Published var amount: Double
    @Published var category: CategoryEntity? = Storage.shared.category.getCategories(from: .current).first
    @Published var selectionCategory: Int = 0
    var transaction: TransactionEntity?
    
    init(transaction: TransactionEntity?) {
        self.transaction = transaction
        self.date = transaction?.date ?? Date()
        self.description = transaction?.description ?? ""
        self.amount = transaction?.amount ?? 0
        if let category = transaction?.category {
            self.category = category
        }
    }
    
    var canAddNewTransaction: Bool {
        return amount > 0 && category != nil && !description.isEmpty
    }
    
    var buttonBackgroundColor: Color {
        return canAddNewTransaction ? .accentColor.opacity(0.2) : .secondary.opacity(0.2)
    }
    
    var buttonForegroundColor: Color {
        return canAddNewTransaction ? (category?.color ?? .accentColor) : .secondary
    }
    
    func loadData() {
        category = Storage.shared.category.getCategories(from: date).first
    }
    
    func loadData(newDate: Date) {
        let categories = Storage.shared.category.getCategories(from: newDate)
        
        if category == nil {
            self.category = categories.first
        } else if let category = category, !categories.map({ $0.id }).contains(category.id) {
            self.category = categories.first
        }
    }
    
    func getCategories() -> [CategoryEntity] {
        Storage.shared.category.getCategories(from: date)
    }
}
