//
//  SideBarScene.swift
//  Budget
//
//  Created by Rafael Santos on 03/01/23.
//

import SwiftUI
import RefdsUI

import Core

@available(iOS 16.0, *)
struct SideBarScene: View {
    @State private var selectionTab: TabItem = .budget
    private let sceneFactory = SceneFactory.shared
    
    var body: some View {
        GeometryReader { proxy in
            NavigationSplitView {
                List(TabItem.allCases, id: \.title) { item in
                    NavigationLink {
                        switch item {
                        case .category: NavigationStack { sceneFactory.makeCategoryScene() }
                        case .budget: NavigationStack { sceneFactory.makeBudgetScene() }
                        case .transaction: NavigationStack { sceneFactory.makeTransactionScene() }
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
            } detail: {
                sceneFactory.makeBudgetScene()
                    .navigationSplitViewColumnWidth(proxy.size.width / 2)
            }
            .navigationSplitViewStyle(.balanced)
        }
    }
}

@available(iOS 16.0, *)
struct SideBarScene_Previews: PreviewProvider {
    static var previews: some View {
        SideBarScene()
    }
}
