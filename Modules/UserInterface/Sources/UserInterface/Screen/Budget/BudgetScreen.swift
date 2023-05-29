//
//  BudgetScreen.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Charts
import Presentation

public struct BudgetScreen<Presenter: BudgetPresenterProtocol>: View {
    @EnvironmentObject private var appConfigurator: AppConfiguration
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            BudgetmacOSView<Presenter>()
                .environmentObject(presenter)
                .onChange(of: appConfigurator.isPro) { _ in presenter.loadData() }
        } else {
            #if os(iOS)
            BudgetiOSView<Presenter>()
                .environmentObject(presenter)
                .onChange(of: appConfigurator.isPro) { _ in presenter.loadData() }
            #endif
        }
    }
}
