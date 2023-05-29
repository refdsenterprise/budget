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
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    @StateObject private var appConfiguration = AppConfiguration.shared
    
    init() {
        #if os(iOS)
        RefdsUI.shared.setNavigationBarAppearance()
        #endif
    }
    
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
                    case .active:
                        appConfiguration.startObserver()
                        #if os(iOS)
                        UserInterface.shortcutItemReceived = shortcutItemReceived
                        shortcutItemReceived = nil
                        #endif
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
