//
//  NotificationManagerString.swift
//  
//
//  Created by Rafael Santos on 06/04/23.
//

import Foundation

public extension Strings {
    enum NotificationManager {
        case navigationTitle
        case allowNotification
        case allowNotificationDescription
        case disableNotificationTitle
        case disableNotificationDescription
        case remiderTitle
        case remiderDescription
        case warningTitle
        case warningDescription
        case breakingTitle
        case breakingDescription
        case options
        case changeNotificationPermission
        
        private var key: String {
            switch self {
            case .navigationTitle: return "navigationTitle"
            case .allowNotification: return "allowNotification"
            case .allowNotificationDescription: return "allowNotificationDescription"
            case .disableNotificationTitle: return "disableNotificationTitle"
            case .disableNotificationDescription: return "disableNotificationDescription"
            case .remiderTitle: return "remiderTitle"
            case .remiderDescription: return "remiderDescription"
            case .warningTitle: return "warningTitle"
            case .warningDescription: return "warningDescription"
            case .breakingTitle: return "breakingTitle"
            case .breakingDescription: return "breakingDescription"
            case .options: return "options"
            case .changeNotificationPermission: return "changeNotificationPermission"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "NotificationManager", bundle: .module, comment: "")
        }
    }
}
