//
//  BudgetApp.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI

@main
struct BudgetApp: App {
    @State private var tabItemSelection: BudgetApp.TabItem = .budget
    
    init() {
        RefdsUI.shared.setNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabItemSelection) {
                CategoryScene()
                BudgetScene()
                TransactionScene()
            }
        }
    }
}

extension BudgetApp {
    enum TabItem: Int {
        case category = 1
        case budget = 2
        case transaction = 3
        
        var title: String {
            switch self {
            case .category: return "Categorias"
            case .budget: return "Budget"
            case .transaction: return "Transações"
            }
        }
    }
}
