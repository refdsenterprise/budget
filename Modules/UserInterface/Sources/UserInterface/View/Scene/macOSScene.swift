//
//  macOSScene.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation

@available(iOS 16.0, *)
struct macOSScene<Presenter: ScenePresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        NavigationSplitView {
            List {
                sectionMainMenu
                sectionCreation
            }
            .listStyle(.sidebar)
            .navigationTitle(presenter.string(.navigationTitle))
        } detail: {
            NavigationStack { presenter.router.configure(routes: .budget) }
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    private var sectionMainMenu: some View {
        Section {
            ForEach(presenter.tabItems, id: \.rawValue) { item in
                NavigationLink {
                    switch item {
                    case .category: NavigationStack { presenter.router.configure(routes: .category) }
                    case .home: NavigationStack { presenter.router.configure(routes: .budget) }
                    case .transaction: NavigationStack { presenter.router.configure(routes: .transactions) }
                    case .settings: NavigationStack { presenter.router.configure(routes: .settings) }
                    }
                } label: { Label { RefdsText(item.title, size: .large) } icon: { item.image } }
            }
        } header: { RefdsText(presenter.string(.headerShowing), size: .large, weight: .bold) }
    }
    
    private var sectionCreation: some View {
        Section {
            ForEach(presenter.creationItems, id: \.rawValue) { item in
                NavigationLink {
                    switch item {
                    case .category: NavigationStack { presenter.router.configure(routes: .addCategory) }
                    case .transaction: NavigationStack { presenter.router.configure(routes: .addTransaction) }
                    case .budget: NavigationStack { presenter.router.configure(routes: .addBudget) }
                    }
                } label: { RefdsText(item.title, size: .large) }
            }
        } header: { RefdsText(presenter.string(.headerCreation), size: .large, weight: .bold) }
    }
}
