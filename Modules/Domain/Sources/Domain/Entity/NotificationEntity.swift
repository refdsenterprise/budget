//
//  NotificationEntity.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import Foundation
import RefdsCore

public struct NotificationEntity: DomainModel {
    public var warningInput: Bool
    public var warningExpensesDate: Date?
    public var breakingExpensesDate: Date?
    public var warningExpensesCategoriesDate: [UUID: Date]
    public var breakingExpensesCategoriesDate: [UUID: Date]
    
    public init(
        warningInput: Bool = false,
        warningExpensesDate: Date? = nil,
        breakingExpensesDate: Date? = nil,
        warningExpensesCategoriesDate: [UUID : Date] = [:],
        breakingExpensesCategoriesDate: [UUID : Date] = [:]
    ) {
        self.warningInput = warningInput
        self.warningExpensesDate = warningExpensesDate
        self.breakingExpensesDate = breakingExpensesDate
        self.warningExpensesCategoriesDate = warningExpensesCategoriesDate
        self.breakingExpensesCategoriesDate = breakingExpensesCategoriesDate
    }
}
