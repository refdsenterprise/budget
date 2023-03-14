//
//  AlertEntity.swift
//  
//
//  Created by Rafael Santos on 10/03/23.
//

import Foundation
import RefdsUI

public struct BudgetAlert {
    public var isPresented: Bool
    public var title: String
    public var message: String?
    public var icon: RefdsIconSymbol?
    
    public init() {
        self.title = ""
        self.message = nil
        self.icon = nil
        self.isPresented = false
    }
    
    public init(title: String, message: String? = nil, icon: RefdsIconSymbol? = nil) {
        self.title = title
        self.message = message
        self.icon = icon
        self.isPresented = true
    }
    
    public init(error: BudgetError) {
        self.title = error.alertTitle
        self.message = error.alertMessage
        self.icon = error.alertIcon
        self.isPresented = true
    }
}
