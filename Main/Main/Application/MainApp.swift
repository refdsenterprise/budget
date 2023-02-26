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

import Core

@main
struct MainApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.scenePhase) private var scenePhase
    @State private var tabItemSelection: TabItem = .budget
    
    private let actionService = ActionService.shared
    private let sceneFactory = SceneFactory.shared
    
    init() {
        RefdsUI.shared.setNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *), Application.isLargeScreen {
                SideBarScene()
                .environmentObject(actionService)
            } else {
                TabView(selection: $tabItemSelection) {
                    NavigationView { sceneFactory.makeCategoryScene() }
                    .tabItem {
                        Image(systemName: "square.stack.3d.forward.dottedline.fill")
                        RefdsText(TabItem.category.title, size: .normal)
                    }
                    .tag(TabItem.category)
                    
                    NavigationView { sceneFactory.makeBudgetScene() }
                    .tabItem {
                        Image(systemName: "dollarsign.square.fill")
                        RefdsText(TabItem.budget.title, size: .normal)
                    }
                    .tag(TabItem.budget)
                    
                    NavigationView { sceneFactory.makeTransactionScene() }
                    .tabItem {
                        Image(systemName: "list.triangle")
                        RefdsText(TabItem.transaction.title, size: .normal)
                    }
                    .tag(TabItem.transaction)
                }
                .environmentObject(actionService)
                .onChange(of: scenePhase) { newValue in
                    switch newValue {
                    case .active: performActionIfNeeded()
                    default: break
                    }
                }
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
    
    var title: String {
        switch self {
        case .category: return "Categorias"
        case .budget: return "Budget"
        case .transaction: return "Transações"
        }
    }
    
    var image: Image {
        switch self {
        case .category: return Image(systemName: "square.stack.3d.forward.dottedline.fill")
        case .budget: return Image(systemName: "dollarsign.square.fill")
        case .transaction: return Image(systemName: "list.triangle")
        }
    }
}
