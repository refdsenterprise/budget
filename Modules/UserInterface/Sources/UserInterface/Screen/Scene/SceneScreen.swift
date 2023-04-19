//
//  SceneScreen.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import SwiftUI
import RefdsUI
import Presentation

public struct SceneScreen<Presenter: ScenePresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS, #available(iOS 16.0, *) {
            macOSScene<Presenter>()
                .environmentObject(presenter)
        } else {
            iOSScene<Presenter>()
                .environmentObject(presenter)
        }
    }
}
