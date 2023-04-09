//
//  MainApp.swift
//  Main
//
//  Created by Rafael Santos on 25/02/23.
//

import SwiftUI
import RefdsUI
import Domain
import UserInterface
import Presentation
import Core

@main
struct MainApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appConfiguration = AppConfiguration.shared
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.scenePhase) private var scenePhase
    @State private var tabItemSelection: TabItem = .budget
    
    private let actionService = ActionService.shared
    private let device: Device = .current
    private let router: MainRouter = .init(factory: Factory.shared)
    
    init() {
        RefdsUI.shared.setNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *), Application.isLargeScreen {
                SideBarScene()
                    .accentColor(appConfiguration.themeColor)
                    .environment(\.appTheme, appConfiguration.themeColor)
                    .environmentObject(appConfiguration)
                    .environmentObject(actionService)
            } else {
                TabView(selection: $tabItemSelection) {
                    NavigationView { router.configure(routes: .category) }
                        .tabItem {
                            TabItem.category.image
                            RefdsText(TabItem.category.title, size: .normal)
                        }
                        .tag(TabItem.category)
                    
                    NavigationView { router.configure(routes: .budget) }
                        .tabItem {
                            TabItem.budget.image
                            RefdsText(TabItem.budget.title, size: .normal)
                        }
                        .tag(TabItem.budget)
                    
                    NavigationView { router.configure(routes: .transactions) }
                        .tabItem {
                            TabItem.transaction.image
                            RefdsText(TabItem.transaction.title, size: .normal)
                        }
                        .tag(TabItem.transaction)
                    
                    NavigationView { router.configure(routes: .settings) }
                        .tabItem {
                            TabItem.settings.image
                            RefdsText(TabItem.settings.title)
                        }
                        .tag(TabItem.settings)
                }
                .accentColor(appConfiguration.themeColor)
                .environment(\.appTheme, appConfiguration.themeColor)
                .environmentObject(appConfiguration)
                .environmentObject(actionService)
                .preferredColorScheme(appConfiguration.colorScheme)
                .onChange(of: scenePhase) { newValue in
                    switch newValue {
                    case .active: performActionIfNeeded()
                    default: break
                    }
                }
                .onAppear { NotificationCenter.shared.makeReminderSetTransactions() }
            }
        }
    }
    
    private func performActionIfNeeded() {
        guard let action = actionService.action else { return }
        switch action {
        case .newCategory: tabItemSelection = .category
        case .newTransaction: tabItemSelection = .transaction
        }
    }
}

enum TabItem: Int, CaseIterable {
    case category = 1
    case budget = 2
    case transaction = 3
    case settings = 4
    
    var title: String {
        switch self {
        case .category: return "Categorias"
        case .budget: return "Budget"
        case .transaction: return "Transações"
        case .settings: return "Ajustes"
        }
    }
    
    var image: Image {
        switch self {
        case .category: return Image(systemName: "square.stack.3d.forward.dottedline.fill")
        case .budget: return Image(systemName: "dollarsign.square.fill")
        case .transaction: return Image(systemName: "list.triangle")
        case .settings: return Image(systemName: RefdsIconSymbol.gear.rawValue)
        }
    }
}
