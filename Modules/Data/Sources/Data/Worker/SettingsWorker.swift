//
//  SettingsWorker.swift
//  
//
//  Created by Rafael Santos on 30/03/23.
//

import SwiftUI
import Domain

public final class SettingsWorker {
    public static let shared = SettingsWorker()
    private let database = Database.shared
    
    public func get() -> SettingsEntity {
        let request = SettingsEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        guard let settings = try? database.viewContext.fetch(request).last else {
            let settings = SettingsEntity(context: database.viewContext)
            settings.date = Date.current
            settings.theme = "#34C759"
            settings.appearence = 0
            settings.notifications = true
            settings.reminderNotification = true
            settings.warningNotification = true
            settings.breakingNotification = true
            settings.currentWarningNotificationAppears = [.init()]
            settings.currentBreakingNotificationAppears = [.init()]
            settings.liveActivity = .init()
            settings.isPro = false
            try? database.viewContext.save()
            return settings
        }
        return settings
    }
    
    public func add(
        theme: String? = nil,
        appearence: Double? = nil,
        notifications: Bool? = nil,
        reminderNotification: Bool? = nil,
        warningNotification: Bool? = nil,
        breakingNotification: Bool? = nil,
        currentWarningNotificationAppears: [UUID]? = nil,
        currentBreakingNotificationAppears: [UUID]? = nil,
        liveActivity: UUID? = nil,
        isPro: Bool? = nil
    ) throws {
        let settings = get()
        settings.date = Date.current
        settings.theme = theme ?? settings.theme
        settings.appearence = appearence ?? settings.appearence
        settings.notifications = notifications ?? settings.notifications
        settings.reminderNotification = reminderNotification ?? settings.reminderNotification
        settings.warningNotification = warningNotification ?? settings.warningNotification
        settings.breakingNotification = breakingNotification ?? settings.breakingNotification
        settings.currentWarningNotificationAppears = currentWarningNotificationAppears ?? settings.currentWarningNotificationAppears
        settings.currentBreakingNotificationAppears = currentBreakingNotificationAppears ?? settings.currentBreakingNotificationAppears
        settings.liveActivity = liveActivity ?? settings.liveActivity
        settings.isPro = isPro ?? settings.isPro
        try database.viewContext.save()
    }
}
