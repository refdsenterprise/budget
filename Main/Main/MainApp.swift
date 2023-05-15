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
import Data
import WidgetKit

@main
struct MainApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appConfiguration = AppConfiguration.shared
    
    init() { RefdsUI.shared.setNavigationBarAppearance() }
    
    var body: some Scene {
        WindowGroup {
            AnyView(Factory.shared.makeSceneScreen())
                .accentColor(appConfiguration.themeColor)
                .environment(\.appTheme, appConfiguration.themeColor)
                .environmentObject(appConfiguration)
                .preferredColorScheme(appConfiguration.colorScheme)
                .onChange(of: scenePhase) { newValue in
                    updateWidget()
                    switch newValue {
                    case .active: appConfiguration.startObserver()
                    default: appConfiguration.stopObserver()
                    }
                }
//                .onAppear {
//                    Worker.shared.category.replaceAllCategories(Mock.categories.data)
//                    Worker.shared.transaction.replaceAllTransactions(Mock.transactions.data)
//                }
        }
    }
    
    func updateWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
