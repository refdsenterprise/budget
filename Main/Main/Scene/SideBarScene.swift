//
//  SideBarScene.swift
//  Budget
//
//  Created by Rafael Santos on 03/01/23.
//

import SwiftUI
import RefdsUI

import Core
import UserInterface
import Presentation

@available(iOS 16.0, *)
struct SideBarScene: View {
    @State private var selectionTab: TabItem = .budget
    private let router = MainRouter(factory: Factory.shared)
    
    var body: some View {
        GeometryReader { proxy in
            NavigationSplitView {
                List(TabItem.allCases, id: \.title) { item in
                    NavigationLink {
                        switch item {
                        case .category: NavigationStack { router.configure(routes: .category) }
                        case .budget: NavigationStack { router.configure(routes: .budget) }
                        case .transaction: NavigationStack { router.configure(routes: .transactions) }
                        }
                    } label: {
                        Label {
                            RefdsText(item.title)
                        } icon: {
                            item.image
                        }
                    }
                }
                .listStyle(.sidebar)
                .navigationTitle("Menu")
            } detail: {
                router.configure(routes: .budget)
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
