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
