//
//  CustomizationScreen.swift
//  
//
//  Created by Rafael Santos on 09/04/23.
//

import SwiftUI
import Presentation

public struct CustomizationScreen<Presenter: CustomizationPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            CustomizationmacOSView<Presenter>()
                .environmentObject(presenter)
        } else {
            #if os(iOS)
            CustomizationiOSView<Presenter>()
                .environmentObject(presenter)
            #endif
        }
    }
}
