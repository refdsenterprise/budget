//
//  SideBarScene.swift
//  Budget
//
//  Created by Rafael Santos on 03/01/23.
//

import SwiftUI
import RefdsUI

@available(iOS 16.0, *)
struct SideBarScene: View {
    var body: some View {
        NavigationSplitView {
            List(BudgetApp.TabItem.allCases, id: \.title) { item in
                NavigationLink {
                    switch item {
                    case .category: NavigationStack { CategoryScene() }
                    case .budget: NavigationStack { BudgetScene() }
                    case .transaction: NavigationStack { TransactionScene() }
                    }
                } label: {
                    Label {
                        RefdsText(item.title)
                    } icon: {
                        item.image
                    }
                }
            }
            .padding()
            .navigationTitle("Menu")
        } detail: {
            BudgetScene()
        }
        .navigationSplitViewStyle(.balanced)
        
    }
}

@available(iOS 16.0, *)
struct SideBarScene_Previews: PreviewProvider {
    static var previews: some View {
        SideBarScene()
    }
}
