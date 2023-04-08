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
                List {
                    Section {
                        ForEach(TabItem.allCases, id: \.title) { item in
                            NavigationLink {
                                switch item {
                                case .category: NavigationStack { router.configure(routes: .category) }
                                case .budget: NavigationStack { router.configure(routes: .budget) }
                                case .transaction: NavigationStack { router.configure(routes: .transactions) }
                                case .settings: NavigationStack { router.configure(routes: .settings) }
                                }
                            } label: {
                                Label {
                                    RefdsText(item.title, size: .large)
                                } icon: {
                                    item.image
                                }
                            }
                        }
                    } header: {
                        RefdsText("Exibição", size: .large, weight: .bold)
                    }
                    
                    Section {
                        NavigationLink(destination: { router.configure(routes: .addTransaction) }) {
                            Label(title: { RefdsText("Adicionar Transação", size: .large) }, icon: { Image(systemName: "text.badge.plus") })
                        }
                        
                        NavigationLink(destination: { router.configure(routes: .addCategory) }) {
                            Label(title: { RefdsText("Adicionar Categoria", size: .large) }, icon: { Image(systemName: "rectangle.stack.fill.badge.plus") })
                        }
                    } header: {
                        RefdsText("Criação", size: .large, weight: .bold)
                    }
                }
                .listStyle(.sidebar)
                .navigationTitle("Menu")
            } detail: {
                router.configure(routes: .budget)
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
