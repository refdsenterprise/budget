//
//  DateExtensions.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import Foundation

public extension Date {
    static var current: Date { return Date() }
    
    func asString(withDateFormat dateFormat: String = "dd/MM/yyyy HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
