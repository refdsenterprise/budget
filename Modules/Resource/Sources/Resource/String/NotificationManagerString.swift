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
        case activeNotifications
        case status
        
        private var key: String {
            switch self {
            case .navigationTitle: return "notification.navigationTitle"
            case .allowNotification: return "notification.allowNotification"
            case .allowNotificationDescription: return "notification.allowNotificationDescription"
            case .disableNotificationTitle: return "notification.disableNotificationTitle"
            case .disableNotificationDescription: return "notification.disableNotificationDescription"
            case .remiderTitle: return "notification.remiderTitle"
            case .remiderDescription: return "notification.remiderDescription"
            case .warningTitle: return "notification.warningTitle"
            case .warningDescription: return "notification.warningDescription"
            case .breakingTitle: return "notification.breakingTitle"
            case .breakingDescription: return "notification.breakingDescription"
            case .options: return "notification.options"
            case .changeNotificationPermission: return "notification.changeNotificationPermission"
            case .activeNotifications: return "notification.activeNotifications"
            case .status: return "notification.status"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
        }
    }
}
