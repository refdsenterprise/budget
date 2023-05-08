//
//  CategoryScreen.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Presentation

public struct CategoryScreen<Presenter: CategoryPresenterProtocol>: View {
    private var isPresentedAddCategory: Bool
    private var isPresentedAddBudget: Bool
    @EnvironmentObject private var appConfigurator: AppConfiguration
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter, isPresentedAddCategory: Bool = false, isPresentedAddBudget: Bool = false) {
        _presenter = StateObject(wrappedValue: presenter)
        self.isPresentedAddCategory = isPresentedAddCategory
        self.isPresentedAddBudget = isPresentedAddBudget
    }
    
    public var body: some View {
        if Device.current == .macOS {
            CategorymacOSView<Presenter>()
                .environmentObject(presenter)
                .onChange(of: appConfigurator.isPro) { _ in presenter.loadData() }
                .onAppear {
                    if isPresentedAddCategory { presenter.isPresentedAddCategory.toggle() }
                    if isPresentedAddBudget { presenter.isPresentedAddBudget.toggle() }
                }
        } else {
            CategoryiOSView<Presenter>()
                .environmentObject(presenter)
                .onChange(of: appConfigurator.isPro) { _ in presenter.loadData() }
                .onAppear {
                    if isPresentedAddCategory { presenter.isPresentedAddCategory.toggle() }
                    if isPresentedAddBudget { presenter.isPresentedAddBudget.toggle() }
                }
        }
    }
}
