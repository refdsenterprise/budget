//
//  File.swift
//  
//
//  Created by Rafael Santos on 24/02/23.
//

import Foundation
import SwiftUI
import Domain
import RefdsUI

public extension View {
    func alertBudgetError(isPresented: Binding<(Bool, BudgetError)>) -> some View {
        self.alert(isPresented.wrappedValue.1.alertTitle, isPresented: isPresented.0.projectedValue, actions: {  }, message: { RefdsText(isPresented.wrappedValue.1.alertMessage) })
    }
}
