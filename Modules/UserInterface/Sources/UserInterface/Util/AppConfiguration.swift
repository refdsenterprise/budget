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
    private var timer = Timer()
    
    public init() {
        NotificationCenter.shared.updateNotificationSettings()
    }
    
    @Published public var themeColor: Color = Color(hex: Worker.shared.settings.get().theme)
    @Published public var colorScheme: ColorScheme? = AppearenceItem(rawValue: Worker.shared.settings.get().appearence.rounded())?.colorScheme
    @Published public var isPro: Bool = Worker.shared.settings.get().isPro
    
    public func startObserver() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            let settings = Worker.shared.settings.get()
            let themeColor = Color(hex: settings.theme)
            let appearence = AppearenceItem(rawValue: settings.appearence)
            let isPro = settings.isPro
            
            self.themeColor = themeColor
            self.colorScheme = appearence?.colorScheme
            self.isPro = isPro
        })
    }
    
    public func stopObserver() {
        timer.invalidate()
    }
}
