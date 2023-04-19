//
//  PeriodItem.swift
//  
//
//  Created by Rafael Santos on 24/02/23.
//

import Foundation
import Resource
import RefdsCore

public enum PeriodItem: Int, CaseIterable {
    case month = 0
    case day = 1
    case week = 2
    case year = 3
    
    public var label: String {
        switch self {
        case .month: return Strings.UserInterface.month.value
        case .day: return Strings.UserInterface.day.value
        case .week: return Strings.UserInterface.week.value
        case .year: return Strings.UserInterface.year.value
        }
    }
    
    public var dateFormat: String.DateFormat {
        switch self {
        case .month, .week: return .monthYear
        case .day: return .dayMonthYear
        case .year: return .custom("yyyy")
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
        case .month, .year: return 1
        case .day: return 30
        case .week: return 4
        }
    }
    
    public var dateFormatFile: String.DateFormat {
        switch self {
        case .day: return .custom("dd/MMMM/yyyy")
        case .week: return .custom("EEE, dd MMM yyyy")
        case .month: return .custom("MMMM/yyyy")
        case .year: return .custom("yyyy")
        }
    }
    
    public static var values: [String] {
        Self.allCases.map { $0.label }
    }
}
