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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
#if targetEnvironment(macCatalyst)
#else
        if #available(iOS 16.1, *) {
            LiveActivityPresenter.shared.activeLiveActivity()
        }
#endif
        
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
              let components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true) else {
            return false
        }
        print(components)
        return true
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        completionHandler(true)
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
