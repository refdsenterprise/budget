//
//  String+Extensions.swift
//  
//
//  Created by Rafael Santos on 18/03/23.
//

import Foundation
import SwiftUI
import RefdsCore

public extension String {
    func asDate(withFormat format: String.DateFormat) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format.value
        return formatter.date(from: self) ?? .current
    }
}
