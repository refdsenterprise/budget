//
//  BudgetWidgetAttributes.swift
//  
//
//  Created by Rafael Santos on 14/03/23.
//

import Foundation
import ActivityKit

public struct BudgetWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var value: Int
        public init(value: Int) {
            self.value = value
        }
    }
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}
