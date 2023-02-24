//
//  Transaction+Extension.swift
//  
//
//  Created by Rafael Santos on 24/02/23.
//

import Foundation
import Domain

extension TransactionEntity {
    public var category: CategoryEntity? { Storage.shared.category.getCategory(by: categoryUUID) }
}
