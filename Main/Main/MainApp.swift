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
import Resource

@main
struct MainApp: App {
    @Environment(\.scenePhase) private var scenePhase
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    @StateObject private var configuration = AppConfiguration.shared
    
    init() {
        #if os(iOS)
        RefdsUI.shared.setNavigationBarAppearance()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            AnyView(Factory.shared.makeSceneScreen())
                .accentColor(configuration.themeColor)
                .environment(\.appTheme, configuration.themeColor)
                .environmentObject(configuration)
                .preferredColorScheme(configuration.colorScheme)
                .refdsAuth(autheticated: $configuration.authenticaded)
                .onboardingView(isFinished: $configuration.onboarding)
                .onChange(of: scenePhase) { newValue in
                    updateWidget()
                    switch newValue {
                    case .active:
                        configuration.startObserver()
                        #if os(iOS)
                        UserInterface.shortcutItemReceived = shortcutItemReceived
                        shortcutItemReceived = nil
                        #endif
                    default:
                        configuration.authenticaded = false
                        configuration.stopObserver()
                    }
                }
        }
    }
    
    func updateWidget() {
        DispatchQueue.main.async {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
