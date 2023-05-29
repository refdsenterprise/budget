//
//  SettingsiOSView.swift
//  
//
//  Created by Rafael Santos on 27/03/23.
//

import SwiftUI
import RefdsUI
import Presentation
#if os(iOS)
struct SettingsiOSView<Presenter: SettingsPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        List {
            sectionConfiguration
            if presenter.needShowModalPro { ProSection() }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(presenter.string(.navigationTitle))
        .onAppear { presenter.loadData() }
    }
    
    private var sectionConfiguration: some View {
        Section {
            if presenter.needShowModalPro {
                rowNotifications
                rowCustomization
            } else {
                NavigationLink(destination: { presenter.router.configure(routes: .notification) }) {
                    rowNotifications
                }
                
                NavigationLink(destination: { presenter.router.configure(routes: .customization) }, label: {
                    rowCustomization
                })
            }
            
            NavigationLink(destination: { presenter.router.configure(routes: .about) }) {
                rowAbout
            }
        } header: {
            RefdsText(presenter.string(.headerConfiguration), size: .extraSmall, color: .secondary)
        }
    }
    
    private var rowNotifications: some View {
        HStack {
            RefdsIcon(symbol: .bellSquareFill, renderingMode: .multicolor)
            RefdsText(presenter.string(.manageNotification))
            Spacer()
            if presenter.needShowModalPro { ProTag() }
        }
    }
    
    private var rowCustomization: some View {
        HStack {
            RefdsIcon(symbol: .heartSquareFill, renderingMode: .multicolor)
            RefdsText(presenter.string(.manageCustomization))
            Spacer()
            if presenter.needShowModalPro { ProTag() }
        }
    }
    
    private var rowAbout: some View {
        HStack {
            RefdsIcon(symbol: .infoSquareFill, renderingMode: .multicolor)
            RefdsText(presenter.string(.aboutApplication))
            Spacer()
        }
    }
}
#endif
