//
//  iOSScene.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import SwiftUI
import RefdsUI
import Presentation
import Domain
#if os(iOS)
public var shortcutItemReceived: ShortcutItem?
public struct iOSScene<Presenter: ScenePresenterProtocol>: View {
    @Environment(\.dismiss) private var dismiss
    @State private var shortcutItem: ShortcutItem?
    @State private var tabSelectionShorcutItem: TabItem?
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var presenter: Presenter
    
    public var body: some View {
        TabView(selection: $presenter.tabItemSelection) {
            ForEach(presenter.tabItems, id: \.rawValue) { item in
                NavigationView {
                    switch item {
                    case .category: presenter.router.configure(routes: .category)
                    case .home: presenter.router.configure(routes: .budget)
                    case .transaction: presenter.router.configure(routes: .transactions)
                    case .settings: presenter.router.configure(routes: .settings)
                    }
                }
                .tabItem {
                    item.image
                    RefdsText(item.title)
                }
                .tag(item)
                .onChange(of: scenePhase) { newValue in
                    switch newValue {
                    case .active:
                        if let shortcutItem = shortcutItemReceived {
                            presenter.tabItemSelection = .home
                            tabSelectionShorcutItem = shortcutItem.tabItem
                            self.shortcutItem = shortcutItem
                            shortcutItemReceived = nil
                        }
                    default: break
                    }
                }
                .sheet(item: $shortcutItem, onDismiss: {
                    if let tabItem = tabSelectionShorcutItem {
                        presenter.tabItemSelection = tabItem
                        tabSelectionShorcutItem = nil
                    }
                }) { shortcutAction(item: $0) }
            }
        }
    }
    
    private var dismissButton: ToolbarItem<(), Button<RefdsIcon>> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button { shortcutItem = nil } label: {
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
    
    private func shortcutAction(item: ShortcutItem) -> some View {
        NavigationView {
            switch item {
            case .addCategory:
                presenter.router.configure(routes: .addCategory)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { dismissButton }
            case .addTransaction:
                presenter.router.configure(routes: .addTransaction)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { dismissButton }
            case .addBudget:
                presenter.router.configure(routes: .addBudget)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { dismissButton }
            }
        }
    }
}
#endif
