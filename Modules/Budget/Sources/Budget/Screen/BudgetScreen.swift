//
//  BudgetScreen.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Charts
import Domain
import Presentation
import UserInterface

public struct BudgetScreen<Presenter: BudgetPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            BudgetmacOSView<Presenter>()
                .environmentObject(presenter)
        } else {
            BudgetiOSView<Presenter>()
                .environmentObject(presenter)
        }
    }
}
