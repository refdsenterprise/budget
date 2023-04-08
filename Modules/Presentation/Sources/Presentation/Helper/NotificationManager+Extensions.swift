//
//  NotificationManager+Extensions.swift
//  
//
//  Created by Rafael Santos on 08/04/23.
//

import Foundation
import Domain
import Data

public extension NotificationManagerEntity {
    func save() {
        BudgetDatabase.shared.set(on: .notificationManager, value: self)
        NotificationCenter.shared.updateNotificationSettings()
    }
}
