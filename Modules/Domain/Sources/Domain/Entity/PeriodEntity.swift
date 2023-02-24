//
//  PeriodEntity.swift
//  
//
//  Created by Rafael Santos on 24/02/23.
//

import Foundation
import RefdsCore

public enum PeriodEntity: Int {
    case month = 0
    case daily = 1
    case week = 2
    
    public var label: String {
        switch self {
        case .month: return "mensal"
        case .daily: return "diário"
        case .week: return "semanal"
        }
    }
    
    public var dateFormat: String.DateFormat {
        switch self {
        case .month: return .monthYear
        case .daily: return .dayMonthYear
        case .week: return .weekMonthYear
        }
    }
    
    public func containsWeek(originalDate: Date, compareDate: Date) -> Bool {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: originalDate)
        let day = calendar.component(.day, from: originalDate)
        let days = Array(1...7).map { weekday in
            if weekday == dayOfWeek { return day }
            else if weekday < dayOfWeek { return day - (dayOfWeek - weekday) }
            else { return day + (weekday - dayOfWeek) }
        }
        let compareDay = calendar.component(.day, from: compareDate)
        return days.contains(compareDay)
    }
    
    public var averageFactor: Double {
        switch self {
        case .month: return 1
        case .daily: return 30
        case .week: return 4
        }
    }
}
