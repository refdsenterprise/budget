//
//  ProScreen.swift
//  
//
//  Created by Rafael Santos on 28/03/23.
//

import SwiftUI
import Presentation

public struct ProScreen<Presenter: ProPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            HStack {}
        } else {
            ProiOSView<Presenter>()
                .environmentObject(presenter)
        }
    }
}
