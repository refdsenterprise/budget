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
import Resource

public extension View {
    func budgetAlert(_ alert: Binding<BudgetAlert>) -> some View {
        self.refdsAlert(isPresented: alert.isPresented) {
            BudgetAlertView(alert: alert)
        } actions: {
            Button(role: .cancel, action: {}, label: {
                RefdsText(Strings.UserInterface.ok.value, size: .small, weight: .bold)
            })
        }
    }
    
    func navigation<C>(isPresented: Binding<Bool>, destination: () -> C) -> some View where C: View {
        self.background(
            NavigationLink(
                destination: destination(),
                isActive: isPresented
            ) { EmptyView() }.hidden()
        )
    }
}
