//
//  NotificationManagerViewData.swift
//  
//
//  Created by Rafael Santos on 06/04/23.
//

import SwiftUI
import Domain

public struct NotificationManagerViewData {
    public var isOn: Bool
    public var title: String
    public var icon: String
    public var description: String
    public var type: NotificationType
    
    public init(isOn: Bool, title: String, icon: String, description: String, type: NotificationType) {
        self.isOn = isOn
        self.title = title
        self.icon = icon
        self.description = description
        self.type = type
    }
}
