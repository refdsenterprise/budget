//
//  SettingsiOSView.swift
//  
//
//  Created by Rafael Santos on 27/03/23.
//

import SwiftUI
import RefdsUI
import Presentation

struct SettingsiOSView<Presenter: SettingsPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        List {
            sectionConfiguration
            sectionPro
        }
        .listStyle(.insetGrouped)
        .navigationTitle(presenter.string(.navigationTitle))
        .sheet(isPresented: $presenter.isPresentedPro, content: { presenter.router.configure(routes: .pro) })
    }
    
    private var sectionConfiguration: some View {
        Section {
            NavigationLink(destination: { presenter.router.configure(routes: .notification) }) {
                HStack {
                    RefdsIcon(symbol: .bellSquareFill, renderingMode: .multicolor)
                    RefdsText(presenter.string(.manageNotification))
                }
            }
            
            NavigationLink(destination: { presenter.router.configure(routes: .customization) }, label: {
                HStack {
                    RefdsIcon(symbol: .heartSquareFill, renderingMode: .multicolor)
                    RefdsText(presenter.string(.manageCustomization))
                }
            })
            
            NavigationLink(destination: { presenter.router.configure(routes: .about) }) {
                HStack {
                    RefdsIcon(symbol: .infoSquareFill, renderingMode: .multicolor)
                    RefdsText(presenter.string(.aboutApplication))
                }
            }
        } header: {
            RefdsText(presenter.string(.headerConfiguration), size: .extraSmall, color: .secondary)
        }
    }
    
    private var sectionPro: some View {
        Section {
            Button { presenter.isPresentedPro.toggle() } label: {
                HStack {
                    RefdsIcon(symbol: .boltSquareFill, renderingMode: .multicolor)
                    RefdsText(presenter.string(.optionPro))
                }
            }
        }
    }
}
