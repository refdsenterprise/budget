//
//  Device.swift
//  
//
//  Created by Rafael Santos on 09/03/23.
//

import Foundation

public enum Device {
    case macOS
    case iOS
    
    public static var current: Device {
        Application.currentDevice
    }
}
