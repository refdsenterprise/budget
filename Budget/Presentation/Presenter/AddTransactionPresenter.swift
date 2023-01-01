//
//  AddTransactionPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI

final class AddTransactionPresenter: ObservableObject {
    static var instance: Self { Self() }
    @Published var date: Date = Date()
    @Published var description: String = ""
    @Published var amount: Double = 0
    @Published var category: CategoryEntity? = Storage.shared.category.getCategories(from: .current).first
    @Published var selectionCategory: Int = 0
    private var transaction: TransactionEntity?
    
    var canAddNewTransaction: Bool {
        return amount > 0 && category != nil
    }
    
    var buttonBackgroundColor: Color {
        return canAddNewTransaction ? .accentColor.opacity(0.2) : .secondary.opacity(0.2)
    }
    
    var buttonForegroundColor: Color {
        return canAddNewTransaction ? .accentColor : .secondary
    }
    
    func loadData() {
        category = Storage.shared.category.getCategories(from: date).first
    }
    
    func getCategories() -> [CategoryEntity] {
        Storage.shared.category.getCategories(from: date)
    }
}
