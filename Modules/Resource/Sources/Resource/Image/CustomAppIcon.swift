//
//  CustomAppIcon.swift
//  
//
//  Created by Rafael Santos on 02/06/23.
//

import Foundation
import SwiftUI

public extension ResourceImage {
    enum CustomAppIcon: String, CaseIterable {
        case `default` = "AppIcon"
        case light = "LightAppIcon"
        case dark = "DarkAppIcon"
        case system = "SystemAppIcon"
        case lightSystem = "LightSystemAppIcon"
        case darkSystem = "DarkSystemAppIcon"
        case lgbt = "LGBTAppIcon"
        
        public var title: String {
            switch self {
            case .`default`: return Strings.AppIcon.`default`.value
            case .light: return Strings.AppIcon.light.value
            case .dark: return Strings.AppIcon.dark.value
            case .system: return Strings.AppIcon.system.value
            case .lightSystem: return Strings.AppIcon.lightSystem.value
            case .darkSystem: return Strings.AppIcon.darkSystem.value
            case .lgbt: return Strings.AppIcon.lgbt.value
            }
        }
        
        public var image: Image {
            Image(rawValue, bundle: .module)
        }
        
        public func changeIcon(onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
            #if os(iOS)
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(self == .default ? nil : self.rawValue) { error in
                    if let _ = error { onError() }
                    else { onSuccess() }
                }
            } else { onError() }
            #endif
        }
    }
}
