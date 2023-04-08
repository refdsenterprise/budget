//
//  SettingsScreen.swift
//  
//
//  Created by Rafael Santos on 27/03/23.
//

import SwiftUI
import Presentation

public struct SettingsScreen<Presenter: SettingsPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            HStack {}
        } else {
            SettingsiOSView<Presenter>()
                .environmentObject(presenter)
        }
    }
}
