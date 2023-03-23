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
    
    public func requestNotificationAuthorization(
        onSuccess: (() -> Void)? = nil,
        onError: ((Error) -> Void)? = nil
    ) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success { onSuccess?() }
            else if let error = error { onError?(error) }
        }
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
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { onError?(error) }
        }
    }
    
    public func makeReminderSetTransactions() {
        var notification: NotificationEntity = BudgetDatabase.shared.get(on: .notification) ?? .init()
        guard !notification.warningInput else { return }
        requestNotificationAuthorization(onSuccess: {
            self.makeNotificationRequest(
                .atHour(20),
                id: .reminder,
                title: "Atualização dos gastos.",
                body: "Já informou as dispesas de hoje? Vai que é rápido"
            )
            notification.warningInput = true
            BudgetDatabase.shared.set(on: .notification, value: notification)
        })
    }
    
    public func makeWarningExpenses(percent: Double, category: String? = nil, actual: Double, total: Double) {
        requestNotificationAuthorization(onSuccess: {
            self.makeNotificationRequest(
                .now,
                id: category == nil ? .warningExpenses : .warningExpensesCategory,
                title: "⚠️ \(category == nil ? "Dispesas atingiram" : "\(category!.capitalized) atingiu") \(String(format: "%02d", Int(percent)))%.",
                body: "Restando apenas \((total - actual).currency) de \(total.currency) calculados."
            )
        })
    }
    
    public func makeWarningBreakExpenses(category: String? = nil) {
        requestNotificationAuthorization(onSuccess: {
            self.makeNotificationRequest(
                .now,
                id: category == nil ? .warningBreak : .warningBreakCategory,
                title: "‼️ Limite de gasto excedido.",
                body: "Os valores previstos para \(category == nil ? "dispesas" : category!.lowercased()) foram ultrapassados."
            )
        })
    }
}

public extension NotificationCenter {
    enum Trigger {
        case now
        case atHour(Int)
        
        public var value: UNNotificationTrigger {
            switch self {
            case .now:
                return UNTimeIntervalNotificationTrigger(timeInterval: 60 * 10, repeats: false)
            case .atHour(let hour):
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.hour = hour
                return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
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
