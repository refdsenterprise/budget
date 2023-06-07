//
//  AddTransactionViewData.swift
//  
//
//  Created by Rafael Santos on 14/04/23.
//

import Foundation
import SwiftUI
import RefdsUI

public struct AddTransactionViewData {
    public var id: UUID = .init()
    public var amount: Double = 0
    public var message: String = ""
    public var category: Category?
    public var categories: [Category]?
    public var date: Date = .current
    
    public struct Category {
        public var id: UUID
        public var color: Color
        public var name: String
        public var remaning: Double
        public var icon: RefdsIconSymbol
    }
}
