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
            })
        ])
        .navigationTitle(presenter.string(.navigationTitle))
        .sheet(isPresented: $presenter.isPresentedPro, content: { presenter.router.configure(routes: .pro) })
    }
    
    private var sectionConfiguration: some View {
        Group {
            NavigationLink(destination: { presenter.router.configure(routes: .notification) }) {
                GroupBox {
                    HStack {
                        RefdsIcon(symbol: .bellSquareFill, renderingMode: .multicolor)
                        RefdsText(presenter.string(.manageNotification))
                        Spacer()
                    }
                }
                .listGroupBoxStyle()
            }
            
            NavigationLink(destination: { presenter.router.configure(routes: .customization) }, label: {
                GroupBox {
                    HStack {
                        RefdsIcon(symbol: .heartSquareFill, renderingMode: .multicolor)
                        RefdsText(presenter.string(.manageCustomization))
                        Spacer()
                    }
                }
                .listGroupBoxStyle()
            })
            
            NavigationLink(destination: { presenter.router.configure(routes: .about) }) {
                GroupBox {
                    HStack {
                        RefdsIcon(symbol: .infoSquareFill, renderingMode: .multicolor)
                        RefdsText(presenter.string(.aboutApplication))
                        Spacer()
                    }
                }
                .listGroupBoxStyle()
            }
            
            NavigationLink(destination: { presenter.router.configure(routes: .pro) }) {
                GroupBox {
                    HStack {
                        RefdsIcon(symbol: .boltSquareFill, renderingMode: .multicolor)
                        RefdsText(presenter.string(.optionPro))
                        Spacer()
                    }
                }
                .listGroupBoxStyle()
            }
        }
    }
}

