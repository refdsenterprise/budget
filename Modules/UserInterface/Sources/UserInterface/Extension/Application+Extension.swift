//
//  ApplicationExtension.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import Foundation
import SwiftUI

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public final class Application {
    public static let shared = Application()
    
    public static var isLargeScreen: Bool {
        UIDevice.current.userInterfaceIdiom == .mac || UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public func endEditing() {
        UIApplication.shared.endEditing()
    }
}
