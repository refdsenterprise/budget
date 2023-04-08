//
//  ApplicationPresenter.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import SwiftUI

public final class ApplicationPresenter {
    public static let shared = ApplicationPresenter()
    
    @StateObject public var categoriesViewData: CategoriesViewData
    @StateObject public var transactionsViewData: TransactionsViewData
    @StateObject public var budgetViewData: BudgetViewData
    
    private init() {
        _categoriesViewData = StateObject(wrappedValue: CategoriesViewData.shared)
        _transactionsViewData = StateObject(wrappedValue: TransactionsViewData.shared)
        _budgetViewData = StateObject(wrappedValue: BudgetViewData.shared)
    }
}
