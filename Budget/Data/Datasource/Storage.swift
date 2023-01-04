//
//  Storage.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI

final class Storage {
    static let shared = Storage()
    let category: CategoryStorage = .shared
    let transaction: TransactionStorage = .shared
    
    func setWidgetData() {
        
    }
}
