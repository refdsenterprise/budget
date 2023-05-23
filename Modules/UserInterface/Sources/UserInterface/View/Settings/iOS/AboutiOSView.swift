//
//  AboutiOSView.swift
//  
//
//  Created by Rafael Santos on 02/04/23.
//

import SwiftUI
import RefdsUI
import Presentation
import Data

struct AboutiOSView<Presenter: AboutPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        List {
            sectionHeader
            sectionDescription
            sectionLinks
        }
        .navigationBarTitleDisplayMode(.inline)
        .share(item: $presenter.appShareItem)
    }
    
    private var sectionHeader: some View {
        Section {} footer: {
            VStack(alignment: .center) {
                AppIconView()
                appTitleVersion
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var sectionDescription: some View {
        Section {} footer: {
            VStack(alignment: .leading) {
                RefdsText(presenter.string(.applicationDescription))
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var sectionLinks: some View {
        Section {
            Button {
                UIApplication.shared.open(presenter.link(.website))
            } label: {
                HStack {
                    RefdsIcon(symbol: .globe, size: 20)
                        .frame(width: 30)
                    RefdsText(presenter.string(.optionWebsite))
                }
            }
            
            Button {
                UIApplication.shared.open(presenter.link(.github))
            } label: {
                HStack {
                    RefdsIcon(symbol: .link, size: 20)
                        .frame(width: 30)
                    RefdsText(presenter.string(.optionGithub))
                }
            }
            
            Button {
                presenter.requestReview()
            } label: {
                HStack {
                    RefdsIcon(symbol: .heart, size: 20)
                        .frame(width: 30)
                    RefdsText(presenter.string(.optionWriteReview))
                }
            }
            
            Button {
                presenter.appShareItem = .init(isPresented: true, url: presenter.link(.appleStore))
            } label: {
                HStack {
                    RefdsIcon(symbol: .squareAndArrowUp, size: 20)
                        .frame(width: 30)
                    RefdsText(presenter.string(.optionShare))
                }
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
