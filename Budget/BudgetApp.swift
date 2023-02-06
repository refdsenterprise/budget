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
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    @Environment(\.scenePhase) private var scenePhase
    @State private var tabItemSelection: BudgetApp.TabItem = .budget
    
    init() {
        #if os(iOS)
        RefdsUI.shared.setNavigationBarAppearance()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
#if targetEnvironment(macCatalyst) || os(macOS)
            SideBarScene()
                .environmentObject(actionService)
#else
            TabView(selection: $tabItemSelection) {
                NavigationView {
                    CategoryScene()
                }
                .tabItem {
                    Image(systemName: "square.stack.3d.forward.dottedline.fill")
                    RefdsText(BudgetApp.TabItem.category.title, size: .normal)
                }
                .tag(BudgetApp.TabItem.category)
                
                NavigationView {
                    BudgetScene()
                }
                .tabItem {
                    Image(systemName: "dollarsign.square.fill")
                    RefdsText(BudgetApp.TabItem.budget.title, size: .normal)
                }
                .tag(BudgetApp.TabItem.budget)
                
                NavigationView {
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

#if os(iOS)
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
#endif
