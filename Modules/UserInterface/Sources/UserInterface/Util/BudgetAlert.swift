//
//  AlertEntity.swift
//  
//
//  Created by Rafael Santos on 10/03/23.
//

import Foundation
import Domain
import SwiftUI
import RefdsUI

public class BudgetAlert: ObservableObject {
    @Published public var isPresented: Bool = false
    public var title: String
    public var message: String?
    public var icon: RefdsIconSymbol?
    
    public init(title: String? = nil, message: String? = nil, icon: RefdsIconSymbol? = nil) {
        self.title = title ?? ""
        self.message = message
    }
    
    public func present(error: BudgetError) {
        self.title = error.alertTitle
        self.message = error.alertMessage
        self.icon = .exclamationmarkOctagonFill
        isPresented = true
    }
}