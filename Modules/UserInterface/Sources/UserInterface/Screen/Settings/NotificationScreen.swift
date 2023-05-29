//
//  NotificationScreen.swift
//  
//
//  Created by Rafael Santos on 08/04/23.
//

import SwiftUI
import Presentation

public struct NotificationScreen<Presenter: NotificationManagerPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            NotificationmacOSView<Presenter>()
                .environmentObject(presenter)
        } else {
            #if os(iOS)
            NotificationiOSView<Presenter>()
                .environmentObject(presenter)
            #endif
        }
    }
}
