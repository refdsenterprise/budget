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

public enum ActionType: String {
    case newTransaction = "Nova Transação"
    case newCategory = "Nova Categoria"
}

public enum Action: Equatable {
    case newTransaction
    case newCategory
    #if os(iOS)
    public init?(shortcutItem: UIApplicationShortcutItem) {
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

public class ActionService: ObservableObject {
    public static let shared = ActionService()

    @Published public var action: Action?
}
