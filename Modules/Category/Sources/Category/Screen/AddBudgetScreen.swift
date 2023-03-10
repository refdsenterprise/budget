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
    @Environment(\.dismiss) var dismiss
    @StateObject private var presenter: Presenter
    private let newBudget: (BudgetEntity) -> Void
    private let device: Device
    
    public init(device: Device, presenter: Presenter, newBudget: @escaping (BudgetEntity) -> Void) {
        self._presenter = StateObject(wrappedValue: presenter)
        self.newBudget = newBudget
        self.device = device
    }
    
    public var body: some View {
        if device == .iOS { AddBudgetiOSView(presenter: presenter, newBudget: newBudget) }
        else { AddBudgetmacOSView(presenter: presenter, newBudget: newBudget) }
    }
}

struct AddBudgetScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AddBudgetScreen(device: .iOS, presenter: AddBudgetPresenter.instance) { _ in }
                    .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            }
        }
        
        Group {
            AddBudgetScreen(device: .macOS, presenter: AddBudgetPresenter.instance) { _ in }
                .previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
        }
    }
}
