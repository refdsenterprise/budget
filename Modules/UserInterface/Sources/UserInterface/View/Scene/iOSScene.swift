//
//  iOSScene.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import SwiftUI
import RefdsUI
import Presentation

public struct iOSScene<Presenter: ScenePresenterProtocol>: View {
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
            }
        }
    }
}
