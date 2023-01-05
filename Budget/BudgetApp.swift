//
//  BudgetApp.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI

@main
struct BudgetApp: App {
    private let actionService = ActionService.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var tabItemSelection: BudgetApp.TabItem = .budget
    
    init() {
        RefdsUI.shared.setNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
#if targetEnvironment(macCatalyst)
            SideBarScene()
                .environmentObject(actionService)
                .withHostingWindow { window in
                    window?.windowScene?.sizeRestrictions?.minimumSize = CGSize(width: 1000, height: 700)
                    window?.windowScene?.sizeRestrictions?.maximumSize = CGSize(width: 1000, height: 700)
                    if let titlebar = window?.windowScene?.titlebar {
                        titlebar.titleVisibility = .hidden
                        titlebar.toolbar = nil
                    }
                }
#else
            TabView(selection: $tabItemSelection) {
                NavigationStack {
                    CategoryScene()
                }
                .tabItem {
                    Image(systemName: "square.stack.3d.forward.dottedline.fill")
                    RefdsText(BudgetApp.TabItem.category.title, size: .normal)
                }
                .tag(BudgetApp.TabItem.category)
                
                NavigationStack {
                    BudgetScene()
                }
                .tabItem {
                    Image(systemName: "dollarsign.square.fill")
                    RefdsText(BudgetApp.TabItem.budget.title, size: .normal)
                }
                .tag(BudgetApp.TabItem.budget)
                
                NavigationStack {
                    TransactionScene()
                }
                .tabItem {
                    Image(systemName: "list.triangle")
                    RefdsText(BudgetApp.TabItem.transaction.title, size: .normal)
                }
                .tag(BudgetApp.TabItem.transaction)
            }
            .environmentObject(actionService)
            .onChange(of: scenePhase) { newValue in
                switch newValue {
                case .active: performActionIfNeeded()
                default: break
                }
            }
#endif
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

extension BudgetApp {
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
}

extension View {
    fileprivate func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

fileprivate struct HostingWindowFinder: UIViewRepresentable {
    var callback: (UIWindow?) -> ()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
