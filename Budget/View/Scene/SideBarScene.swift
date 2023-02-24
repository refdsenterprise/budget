//
//  SideBarScene.swift
//  Budget
//
//  Created by Rafael Santos on 03/01/23.
//

import SwiftUI
import RefdsUI
import Category
import Transaction

@available(iOS 16.0, *)
struct SideBarScene: View {
    var content: () -> any View
    
    init(content: @escaping () -> any View) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            NavigationSplitView {
                List(BudgetApp.TabItem.allCases, id: \.title) { item in
                    NavigationLink {
                        switch item {
                        case .category: NavigationStack { CategoryScene { category, date in
                            TransactionScene(category: category, date: date) {
                                AddCategoryScene()
                            }
                        } }
                        case .budget: NavigationStack { BudgetScene() }
                        case .transaction: NavigationStack { TransactionScene {
                            AddCategoryScene()
                        } }
                        }
                    } label: {
                        Label {
                            RefdsText(item.title)
                        } icon: {
                            item.image
                        }
                    }
                }
                .navigationTitle("Menu")
            } content: {
                
                BudgetScene()
                    .navigationSplitViewColumnWidth(proxy.size.width / 2)
            } detail: {
                AnyView(content())
            }
            .navigationSplitViewStyle(.balanced)
        }
    }
}

@available(iOS 16.0, *)
struct SideBarScene_Previews: PreviewProvider {
    static var previews: some View {
        SideBarScene { EmptyView() } 
    }
}
