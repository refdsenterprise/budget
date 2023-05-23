//
//  NotificationCenter.swift
//  
//
//  Created by Rafael Santos on 15/03/23.
//

import Foundation
import Data
import UserNotifications
import Domain

public final class NotificationCenter {
    public static let shared = NotificationCenter()
    private let notificationCenter = UNUserNotificationCenter.current()
    private var settings: SettingsEntity { Worker.shared.settings.get() }
    
    public func requestNotificationAuthorization(
        onSuccess: (() -> Void)? = nil,
        onError: ((Error) -> Void)? = nil
    ) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success { onSuccess?() }
            else if let error = error { onError?(error) }
        }
    }
    
    public func notificationSettings(authorizationStatus: ((Bool) -> Void)? = nil) {
        notificationCenter.getNotificationSettings { notificationSettings in
            switch notificationSettings.authorizationStatus {
            case .authorized: authorizationStatus?(true)
            default: authorizationStatus?(false)
            }
        }
    }
    
    public func updateNotificationSettings() {
        let needStop = !settings.reminderNotification
        makeReminderSetTransactions(needStop: needStop)
        let breakingExpenses = settings.currentBreakingNotificationAppears.map({ Worker.shared.category.getBudget(in: $0) }).filter({ ($0?.date.date ?? Date.current).asString(withDateFormat: .monthYear) == Date.current.asString(withDateFormat: .monthYear) && $0 != nil }).map({ $0!.id })
        let warinigExpenses = settings.currentWarningNotificationAppears.map({ Worker.shared.category.getBudget(in: $0) }).filter({ ($0?.date.date ?? Date.current).asString(withDateFormat: .monthYear) == Date.current.asString(withDateFormat: .monthYear) && $0 != nil }).map({ $0!.id })
        try? Worker.shared.settings.add(currentWarningNotificationAppears: warinigExpenses, currentBreakingNotificationAppears: breakingExpenses)
    }
    
    public func makeNotificationRequest(_ trigger: Trigger, id: Identifier, title: String? = nil, subtitle: String? = nil, body: String? = nil, onError: ((Error) -> Void)? = nil) {
        let content = UNMutableNotificationContent()
        if let title = title { content.title = title }
        if let subtitle = subtitle { content.subtitle = subtitle }
        if let body = body { content.body = body }
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: id.rawValue,
            content: content,
            trigger: trigger.value
        )
        notificationCenter.add(request) { error in
            if let error = error { onError?(error) }
        }
    }
    
    public func makeReminderSetTransactions(needStop: Bool = false) {
        guard !settings.reminderNotification || !needStop else { return }
        requestNotificationAuthorization(onSuccess: {
            self.makeNotificationRequest(
                .atHour(20, needStop),
                id: .reminder,
                title: "Atualização dos gastos.",
                body: "Já informou as dispesas de hoje? Vai que é rápido"
            )
        })
    }
    
    public func makeWarningExpenses(budgetID: UUID, percent: Double, category: String? = nil, actual: Double, total: Double) {
        guard settings.warningNotification else { return }
        requestNotificationAuthorization(onSuccess: {
            self.makeNotificationRequest(
                .now,
                id: category == nil ? .warningExpenses : .warningExpensesCategory,
                title: "⚠️ \(category == nil ? "Dispesas atingiram" : "\(category!.capitalized) atingiu") \(String(format: "%02d", Int(percent)))%.",
                body: "Restando apenas \((total - actual).currency) de \(total.currency) calculados."
            )
            try? Worker.shared.settings.add(currentWarningNotificationAppears: self.settings.currentWarningNotificationAppears + [budgetID])
        })
    }
    
    public func makeWarningBreakExpenses(budgetID: UUID, category: String? = nil) {
        guard settings.breakingNotification else { return }
        requestNotificationAuthorization(onSuccess: {
            self.makeNotificationRequest(
                .now,
                id: category == nil ? .warningBreak : .warningBreakCategory,
                title: "‼️ Limite de gasto excedido.",
                body: "Os valores previstos para \(category == nil ? "dispesas" : category!.lowercased()) foram ultrapassados."
            )
            try? Worker.shared.settings.add(currentBreakingNotificationAppears: self.settings.currentBreakingNotificationAppears + [budgetID])
        })
    }
}

public extension NotificationCenter {
    enum Trigger {
        case now
        case atHour(Int, Bool)
        
        public var value: UNNotificationTrigger {
            switch self {
            case .now:
                return UNTimeIntervalNotificationTrigger(timeInterval: 6, repeats: false)
            case .atHour(let hour, let needStop):
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                if needStop { dateComponents.second = 2 }
                else { dateComponents.hour = hour }
                return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: !needStop)
            }
        }
    }
    
    enum Identifier: String {
        case reminder = "budget.add.remeider"
        case warningExpenses = "budget.warning.expenses"
        case warningExpensesCategory = "budget.warning.expenses.category"
        case warningBreak = "budget.warning.break"
        case warningBreakCategory = "budget.warning.break.category"
    }
}
