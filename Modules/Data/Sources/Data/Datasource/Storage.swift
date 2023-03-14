//
//  Storage.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI

public final class Storage {
    public static let shared = Storage()
    public let category: CategoryStorage = .shared
    public let transaction: TransactionStorage = .shared
}

import Combine

fileprivate var cancellables = [String : AnyCancellable] ()

public extension Published {
    init(wrappedValue defaultValue: Value, key: String) {
        let value = UserDefaults(suiteName: "group.budget.3dd8df9f-624a-42d4-9a5c-088d0a0f01eb")?.object(forKey: key) as? Value ?? defaultValue
        self.init(initialValue: value)
        cancellables[key] = projectedValue.sink { val in
            UserDefaults.standard.set(val, forKey: key)
        }
    }
}
