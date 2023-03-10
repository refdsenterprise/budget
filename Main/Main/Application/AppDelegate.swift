//
//  AppDelegate.swift
//  Budget
//
//  Created by Rafael Santos on 04/01/23.
//

import Domain
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    private let actionService = ActionService.shared
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            actionService.action = Action(shortcutItem: shortcutItem)
        }
        
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
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    private let actionService = ActionService.shared
    
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        actionService.action = Action(shortcutItem: shortcutItem)
        completionHandler(true)
    }
}
