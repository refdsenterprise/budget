//
//  ProScreen.swift
//  
//
//  Created by Rafael Santos on 28/03/23.
//

import SwiftUI
import Presentation

public struct ProScreen<Presenter: ProPresenterProtocol>: View {
    @EnvironmentObject private var appConfigurator: AppConfiguration
    @Environment(\.dismiss) private var dismiss
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            PromacOSView<Presenter>()
                    .environmentObject(presenter)
                    .onChange(of: appConfigurator.isPro) { newValue in
                        guard newValue else { return }
                        dismiss()
                    }
        } else {
            #if os(iOS)
            ProiOSView<Presenter>()
                .environmentObject(presenter)
                .onChange(of: appConfigurator.isPro) { newValue in
                    guard newValue else { return }
                    dismiss()
                }
            #endif
        }
    }
}
