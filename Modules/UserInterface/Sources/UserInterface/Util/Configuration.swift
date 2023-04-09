//
//  AppConfiguration.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import Foundation
import SwiftUI
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
    
    @Published public var themeColor: Color = Storage.shared.settings.customization.themeColor {
        didSet { Storage.shared.settings.customization.themeColor = themeColor }
    }
    
    @Published public var colorScheme: ColorScheme? = Storage.shared.settings.customization.appearence.colorScheme {
        didSet { Storage.shared.settings.customization.appearence = colorScheme == .light ? .light : colorScheme == .dark ? .dark : .automatic }
    }
}
