//
//  AddBudgetScreen.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation
import UserInterface

public struct AddBudgetScreen<Presenter: AddBudgetPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    private let newBudget: ((BudgetEntity) -> Void)?
    @Environment(\.dismiss) var dismiss
    
    public init(presenter: Presenter, newBudget: ((BudgetEntity) -> Void)? = nil) {
        self._presenter = StateObject(wrappedValue: presenter)
        self.newBudget = newBudget
    }
    
    public var body: some View {
        if Device.current == .macOS {
            AddBudgetmacOSView<Presenter>(newBudget: newBudget)
                .environmentObject(presenter)
        } else {
            AddBudgetiOSView<Presenter>(newBudget: newBudget)
                .environmentObject(presenter)
        }
    }
}
