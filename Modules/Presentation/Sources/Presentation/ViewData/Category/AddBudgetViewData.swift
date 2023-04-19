//
//  AddBudgetViewData.swift
//  
//
//  Created by Rafael Santos on 14/04/23.
//

import Foundation
import SwiftUI

public struct AddBudgetViewData {
    public var id: UUID = .init()
    public var amount: Double = 0
    public var date: Date = .current { didSet { bind() } }
    public var message: String = ""
    public var category: Category?
    public var categories: [Category]?
    public var bind: () -> Void = {}
    
    public struct Category {
        public var id: UUID
        public var color: Color
        public var name: String
    }
}
