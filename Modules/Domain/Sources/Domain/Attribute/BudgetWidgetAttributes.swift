//
//  BudgetWidgetAttributes.swift
//  
//
//  Created by Rafael Santos on 14/03/23.
//

import Foundation
import SwiftUI
#if os(iOS)
import ActivityKit

public struct BudgetWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var id: String = UUID().uuidString
        public var diff: Double
        public var totalBudget: Double
        public var diffColor: Color
        public var totalActual: Double
        public var chartData: [ChartDataItem]
        public var isEmpty: Bool
        public var isActive: Bool
        
        public init(diff: Double, totalBudget: Double, diffColor: Color, totalActual: Double, chartData: [ChartDataItem], isEmpty: Bool, isActive: Bool) {
            self.diff = diff
            self.totalBudget = totalBudget
            self.diffColor = diffColor
            self.totalActual = totalActual
            self.chartData = chartData
            self.isEmpty = isEmpty
            self.isActive = isActive
        }
        
        public func hash(into hasher: inout Hasher) {
                return hasher.combine(id)
            }
        
        public static func == (lhs: BudgetWidgetAttributes.ContentState, rhs: BudgetWidgetAttributes.ContentState) -> Bool {
            return lhs.id == rhs.id
        }
    }
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}
#endif

public struct ChartDataItem: Codable {
    public var label: String
    public var data: [DataItem]
    
    public init(label: String, data: [DataItem]) {
        self.label = label
        self.data = data
    }
    
    public struct DataItem: Codable {
        public var category: String
        public var value: Double
        
        public init(category: String, value: Double) {
            self.category = category
            self.value = value
        }
    }
}
