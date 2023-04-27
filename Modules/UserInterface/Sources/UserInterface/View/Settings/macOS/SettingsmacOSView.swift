//
//  SettingsmacOSView.swift
//  
//
//  Created by Rafael Santos on 17/04/23.
//

import SwiftUI
import RefdsUI
import Presentation

struct SettingsmacOSView<Presenter: SettingsPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        MacUIView(sections: [
            .init(maxAmount: nil, content: {
                Group { sectionConfiguration }
            }),
            .init(maxAmount: 2, content: {
                Group {
                    if presenter.needShowModalPro { ProSection() }
                }
            })
        ])
        .navigationTitle(presenter.string(.navigationTitle))
        .onAppear { presenter.loadData() }
    }
    
    private var sectionConfiguration: some View {
        Group {
            if presenter.needShowModalPro {
                GroupBox { rowNotifications }
                .listGroupBoxStyle()
                
                GroupBox { rowCustomization }
                .listGroupBoxStyle()
            } else {
                NavigationLink(destination: { presenter.router.configure(routes: .notification) }) {
                    GroupBox { rowNotifications }
                        .listGroupBoxStyle(isButton: true)
                }
                
                NavigationLink(destination: { presenter.router.configure(routes: .customization) }, label: {
                    GroupBox { rowCustomization }
                        .listGroupBoxStyle(isButton: true)
                })
            }
            
            NavigationLink(destination: { presenter.router.configure(routes: .about) }) {
                GroupBox { rowAbout }
                .listGroupBoxStyle(isButton: true)
            }
        }
    }
    
    private var rowNotifications: some View {
        HStack {
            RefdsIcon(symbol: .bellSquareFill, renderingMode: .multicolor)
            RefdsText(presenter.string(.manageNotification))
            Spacer()
            if presenter.needShowModalPro {
                RefdsTag("PRO", color: .yellow)
            }
        }
    }
    
    private var rowCustomization: some View {
        HStack {
            RefdsIcon(symbol: .heartSquareFill, renderingMode: .multicolor)
            RefdsText(presenter.string(.manageCustomization))
            Spacer()
            if presenter.needShowModalPro {
                RefdsTag("PRO", color: .yellow)
            }
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

