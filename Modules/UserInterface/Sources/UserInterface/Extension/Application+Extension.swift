//
//  ApplicationExtension.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import Foundation
import SwiftUI

#if os(iOS)
public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

public final class Application {
    public static let shared = Application()
    
    public static var isLargeScreen: Bool {
        #if os(iOS)
        UIDevice.current.userInterfaceIdiom == .mac || UIDevice.current.userInterfaceIdiom == .pad
        #else
        return true
        #endif
        
    }
    
    public static var currentDevice: Device {
        isLargeScreen ? .macOS : .iOS
    }
    
    public func endEditing() {
        #if os(iOS)
        UIApplication.shared.endEditing()
        #endif
    }
}
