//
//  AppDelegate.swift
//  Budget
//
//  Created by Rafael Santos on 04/01/23.
//

import Domain
import Resource
import RefdsUI
#if os(macOS)
#else
import UIKit
import ActivityKit
#endif
import Core
import Presentation
import Data

#if os(iOS)
var shortcutItemReceived: ShortcutItem?
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        configureQuickAction()
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
    
    private func configureQuickAction() {
        let addTransactionItem = UIApplicationShortcutItem(
            type: Strings.QuickAction.addTransaction.actionType,
            localizedTitle: Strings.QuickAction.addTransaction.value,
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(systemImageName: RefdsIconSymbol.listBulletRectangleFill.rawValue)
        )
        
        let addCategoryItem = UIApplicationShortcutItem(
            type: Strings.QuickAction.addCategory.actionType,
            localizedTitle: Strings.QuickAction.addCategory.value,
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(systemImageName: RefdsIconSymbol.squareStack3DForwardDottedlineFill.rawValue)
        )
        
        let addBudgetItem = UIApplicationShortcutItem(
            type: Strings.QuickAction.addBudget.actionType,
            localizedTitle: Strings.QuickAction.addBudget.value,
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(systemImageName: RefdsIconSymbol.dollarsignSquareFill.rawValue)
        )
        
        UIApplication.shared.shortcutItems = []
        UIApplication.shared.shortcutItems = [addBudgetItem, addCategoryItem, addTransactionItem]
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
              let _ = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true) else {
            return
        }
    }
}
#endif
