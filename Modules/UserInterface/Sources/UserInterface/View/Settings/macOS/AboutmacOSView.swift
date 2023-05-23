//
//  AboutmacOSView.swift
//  
//
//  Created by Rafael Santos on 17/04/23.
//

import SwiftUI
import RefdsUI
import Presentation
import Data

struct AboutmacOSView<Presenter: AboutPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        MacUIView(sections: [
            .init(maxAmount: 1, content: {
                sectionHeader
            }),
            .init(maxAmount: 1, content: {
                sectionDescription
            }),
            .init(content: {
                sectionLinks
            })
        ])
        .navigationBarTitleDisplayMode(.inline)
        .share(item: $presenter.appShareItem)
    }
    
    private var sectionHeader: some View {
        VStack(alignment: .center, spacing: 20) {
            AppIconView()
            appTitleVersion
        }
        .frame(maxWidth: .infinity)
    }
    
    private var sectionDescription: some View {
        VStack(alignment: .leading) {
            RefdsText(presenter.string(.applicationDescription))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var sectionLinks: some View {
        Group {
            Button {
                UIApplication.shared.open(presenter.link(.website))
            } label: {
                GroupBox {
                    HStack {
                        RefdsIcon(symbol: .globe, size: 20)
                            .frame(width: 30)
                        RefdsText(presenter.string(.optionWebsite))
                        Spacer()
                    }
                }.listGroupBoxStyle()
            }
            
            Button {
                UIApplication.shared.open(presenter.link(.github))
            } label: {
                GroupBox {
                    HStack {
                        RefdsIcon(symbol: .link, size: 20)
                            .frame(width: 30)
                        RefdsText(presenter.string(.optionGithub))
                        Spacer()
                    }
                }.listGroupBoxStyle()
            }
            
            Button { presenter.requestReview() } label: {
                GroupBox {
                    HStack {
                        RefdsIcon(symbol: .heart, size: 20)
                            .frame(width: 30)
                        RefdsText(presenter.string(.optionWriteReview))
                        Spacer()
                    }
                }.listGroupBoxStyle()
            }
            
            Button {
                presenter.appShareItem = .init(isPresented: true, url: presenter.link(.appleStore))
            } label: {
                GroupBox {
                    HStack {
                        RefdsIcon(symbol: .squareAndArrowUp, size: 20)
                            .frame(width: 30)
                        RefdsText(presenter.string(.optionShare))
                        Spacer()
                    }
                }.listGroupBoxStyle()
            }
        }
    }
    
    private var appTitleVersion: some View {
        VStack {
            RefdsText(presenter.string(.applicationName), size: .extraLarge, weight: .bold)
            RefdsText(presenter.string(.applicationAuthor), color: .secondary)
            RefdsTag(presenter.appVersion, size: .small, color: .accentColor)
        }
    }
}
