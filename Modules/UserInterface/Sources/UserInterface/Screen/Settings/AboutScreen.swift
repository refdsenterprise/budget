//
//  AboutScreen.swift
//  
//
//  Created by Rafael Santos on 30/03/23.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation

public struct AboutScreen<Presenter: AboutPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        AboutView<Presenter>()
            .environmentObject(presenter)
    }
}
