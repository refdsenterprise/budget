//
//  AppConfiguration.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import Presentation
import Domain
import Data

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: Color = .accentColor
}

public extension EnvironmentValues {
    var appTheme: Color {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

public final class AppConfiguration: ObservableObject {
    public static let shared = AppConfiguration()
    @MainActor private let proPresenter = ProPresenter.shared
    @AppStorage(.refdsString(.storage(.onboarding))) public var onboarding: Bool = false
    @AppStorage(.refdsString(.storage(.auth))) public var allowAuth: Bool = false {
        didSet { authenticaded = !allowAuth }
    }
    
    private var timer = Timer()
    
    public init() {
        NotificationCenter.shared.updateNotificationSettings()
    }
    
    @Published public var themeColor: Color = Color(hex: Worker.shared.settings.get().theme)
    @Published public var colorScheme: ColorScheme? = AppearenceItem(rawValue: Worker.shared.settings.get().appearence.rounded())?.colorScheme
    @Published public var isPro: Bool = true//Worker.shared.settings.get().isPro
    @Published public var authenticaded: Bool = false
    
    public func startObserver() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            let settings = Worker.shared.settings.get()
            let themeColor = Color(hex: settings.theme)
            let appearence = AppearenceItem(rawValue: settings.appearence)
            //let isPro = settings.isPro
            
            if self.themeColor != themeColor { self.themeColor = themeColor }
            if self.colorScheme != appearence?.colorScheme { self.colorScheme = appearence?.colorScheme }
            //self.isPro = isPro
            
//            if !isPro, settings.notifications {
//                try? Worker.shared.settings.add(
//                    notifications: false,
//                    reminderNotification: false,
//                    warningNotification: false,
//                    breakingNotification: false,
//                    currentWarningNotificationAppears: [],
//                    currentBreakingNotificationAppears: []
//                )
//            }
//            
//            if !isPro {
//                allowAuth = false
//            }
        })
    }
    
    public func stopObserver() {
        timer.invalidate()
    }
}
