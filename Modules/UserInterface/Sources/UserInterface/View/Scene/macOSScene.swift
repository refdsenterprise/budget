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

@available(macOS 13.0, *)
@available(iOS 16.0, *)
struct macOSScene<Presenter: ScenePresenterProtocol>: View {
    @Environment(\.dismiss) private var dismiss
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
    
    private var dismissButton: ToolbarItem<(), RefdsButton> {
        ToolbarItem {
            RefdsButton { presenter.creationItemSelection = nil } label: {
                RefdsIcon(
                    symbol: .xmarkCircleFill,
                    color: .secondary,
                    size: 20,
                    weight: .medium,
                    renderingMode: .hierarchical
                )
            }
        }
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
                } label: { Label { RefdsText(item.title) } icon: { item.image } }
                #if os(macOS)
                    .padding(.vertical, 2)
                #endif
            }
        } header: { RefdsText(presenter.string(.headerShowing).uppercased(), style: .caption1, color: .secondary) }
    }
    
    private var sectionCreation: some View {
        Section {
            ForEach(presenter.creationItems, id: \.rawValue) { item in
                NavigationLink {
                    NavigationStack {
                        switch item {
                        case .category:
                            presenter.router.configure(routes: .category)
                                .sheet(item: $presenter.creationItemSelection) { creationContentSheet(item: $0) }
                                .onAppear { presenter.creationItemSelection = item }
                        case .transaction:
                            presenter.router.configure(routes: .transactions)
                                .sheet(item: $presenter.creationItemSelection) { creationContentSheet(item: $0) }
                                .onAppear { presenter.creationItemSelection = item }
                        case .budget:
                            presenter.router.configure(routes: .category)
                                .sheet(item: $presenter.creationItemSelection) { creationContentSheet(item: $0) }
                                .onAppear { presenter.creationItemSelection = item }
                        }
                    }
                } label: { Label { RefdsText(item.title) } icon: { item.image } }
                #if os(macOS)
                    .padding(.vertical, 2)
                #endif
            }
        } header: { RefdsText(presenter.string(.headerCreation).uppercased(), style: .caption1, color: .secondary) }
    }
    
    private func creationContentSheet(item: CreationItem) -> some View {
        NavigationStack {
            switch item {
            case .category:
                presenter.router.configure(routes: .addCategory)
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
                    .toolbar { dismissButton }
                    
            case .transaction:
                presenter.router.configure(routes: .addTransaction)
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
                    .toolbar { dismissButton }
                    
            case .budget:
                presenter.router.configure(routes: .addBudget)
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
                    .toolbar { dismissButton }
            }
        }
        #if os(macOS)
        .frame(width: 700, height: 400)
        #endif
    }
}
