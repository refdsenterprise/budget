//
//  BudgetDatabase.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import Foundation
import RefdsCore
import Domain
import SwiftUI

public final class BudgetDatabase: ObservableObject {
    public static let shared = BudgetDatabase()
    private let userDefaults = UserDefaults(suiteName: "group.budget.3dd8df9f-624a-42d4-9a5c-088d0a0f01eb")
    
    public func set(on key: Key, value: Encodable, onError: ((BudgetError) -> Void)? = nil) {
        if let data = value.asData {
            userDefaults?.set(data, forKey: key.value)
        } else { onError?(.cantSaveOnDatabase) }
    }
    
    public func get<T: Decodable>(on key: Key) -> T? {
        guard let data = userDefaults?.data(forKey: key.value),
              let decodable: T = data.asModel() else { return nil }
        return decodable
    }
}

public extension BudgetDatabase {
    enum Key {
        case categories
        case transactions
        case notification
        case appIcon
        case notificationManager
        
        public var value: String {
            switch self {
            case .categories: return "categories"
            case .transactions: return "transactions"
            case .notification: return "notification"
            case .appIcon: return "appIcon"
            case .notificationManager: return "notificationManager"
            }
        }
    }
}




