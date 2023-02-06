//
//  QuickActionEntity.swift
//  Budget
//
//  Created by Rafael Santos on 04/01/23.
//

import Foundation
#if os(iOS)
import UIKit
#endif

enum ActionType: String {
    case newTransaction = "Nova Transação"
    case newCategory = "Nova Categoria"
}

enum Action: Equatable {
    case newTransaction
    case newCategory
    #if os(iOS)
    init?(shortcutItem: UIApplicationShortcutItem) {
        guard let type = ActionType(rawValue: shortcutItem.type) else {
            return nil
        }
            
        switch type {
        case .newCategory: self = .newCategory
        case .newTransaction: self = .newTransaction
        }
    }
    #endif
}

class ActionService: ObservableObject {
    static let shared = ActionService()

    @Published var action: Action?
}
