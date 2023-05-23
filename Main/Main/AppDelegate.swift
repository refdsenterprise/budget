//
//  AppDelegate.swift
//  Budget
//
//  Created by Rafael Santos on 04/01/23.
//

import Domain
import UIKit
#if targetEnvironment(macCatalyst)
#else
import ActivityKit
#endif
import Core
import Presentation
import Data

var shortcutItemReceived: ShortcutItem?
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        for scene in application.connectedScenes {
            if let windowScene = (scene as? UIWindowScene) {
                #if targetEnvironment(macCatalyst)
                if let titlebar = windowScene.titlebar {
                    titlebar.titleVisibility = .hidden
                    titlebar.toolbar = nil
                }
                #endif
            }
        }
        
        let configuration = UISceneConfiguration(
            name: connectingSceneSession.configuration.name,
            sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
    
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler:
        @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL,
              let _ = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true) else {
            return false
        }
        return true
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        if let shortcutItem = ShortcutItem(rawValue: shortcutItem.type) {
            shortcutItemReceived = shortcutItem
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let shortcutItem = connectionOptions.shortcutItem, let shortcutItem = ShortcutItem(rawValue: shortcutItem.type) {
            shortcutItemReceived = shortcutItem
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL,
              let components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true) else {
            return
        }
        
        print(components)
    }
}
