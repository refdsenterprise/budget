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

public enum NotificationType: DomainModel {
    case remider
    case warning
    case breaking
}

public struct NotificationManagerEntity: DomainModel {
    public var notificationsIsOn: Bool {
        didSet {
            if !notificationsIsOn {
                remiderIsOn = notificationsIsOn
                warningIsOn = notificationsIsOn
                breakingIsOn = notificationsIsOn
            }
        }
    }
    public var remiderIsOn: Bool
    public var warningIsOn: Bool
    public var breakingIsOn: Bool
    
    public init(
        notificationsIsOn: Bool = true,
        remiderIsOn: Bool = true,
        warningIsOn: Bool = true,
        breakingIsOn: Bool = true
    ) {
        self.notificationsIsOn = notificationsIsOn
        self.remiderIsOn = remiderIsOn
        self.warningIsOn = warningIsOn
        self.breakingIsOn = breakingIsOn
    }
}
