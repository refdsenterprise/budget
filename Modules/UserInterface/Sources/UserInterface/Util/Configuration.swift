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
    private var timer = Timer()
    
    public init() {
        NotificationCenter.shared.makeReminderSetTransactions()
    }
    
    @Published public var themeColor: Color = Color(hex: Worker.shared.settings.get().theme)
    @Published public var colorScheme: ColorScheme? = AppearenceItem(rawValue: Worker.shared.settings.get().appearence.rounded())?.colorScheme
    
    public func startObserver() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            let settings = Worker.shared.settings.get()
            let themeColor = Color(hex: settings.theme)
            let appearence = AppearenceItem(rawValue: settings.appearence)
            self.themeColor = themeColor
            self.colorScheme = appearence?.colorScheme
        })
    }
    
    public func stopObserver() {
        timer.invalidate()
    }
}
