//
//  AboutView.swift
//  
//
//  Created by Rafael Santos on 02/04/23.
//

import SwiftUI
import RefdsUI
import Presentation
import Resource
import Data

struct AboutView<Presenter: AboutPresenterProtocol>: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        RefdsList { proxy in
            sectionHeader(proxy: proxy)
            sectionDescription(proxy: proxy)
            sectionLinks(proxy: proxy)
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .share(item: $presenter.appShareItem)
        #endif
    }
    
    private func sectionHeader(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy, header: nil) {
            VStack(alignment: .center) {
                
                HStack(spacing: -10) {
                    appIcon(.lightSystem, size: 40)
                    appIcon(.dark, size: 50)
                    appIcon(.lgbt, size: 60)
                    appIcon(.default, size: 100)
                    appIcon(.light, size: 60)
                    appIcon(.system, size: 50)
                    appIcon(.darkSystem, size: 40)
                }
                
                appTitleVersion
            }
            .frame(maxWidth: .infinity)
        } content: {}
    }
    
    private func appIcon(_ icon: ResourceImage.CustomAppIcon, size: CGFloat) -> some View {
        icon.image
            .resizable()
            .frame(width: size, height: size)
            .cornerRadius(size / 4)
            .padding(.vertical, 5)
            .refdsShadow()
    }
    
    private func sectionDescription(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy, header: nil) {
            RefdsText(presenter.string(.applicationDescription))
        } content: {}
    }
    
    private func sectionLinks(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy) {
            RefdsRow {
                #if os(iOS)
                UIApplication.shared.open(presenter.link(.website))
                #else
                NSWorkspace.shared.open(presenter.link(.website))
                #endif
            } content: {
                HStack {
                    RefdsIcon(symbol: .globe, size: 20)
                        .frame(width: 30)
                    RefdsText(presenter.string(.optionWebsite))
                }
            }
            
            RefdsRow {
                #if os(iOS)
                UIApplication.shared.open(presenter.link(.github))
                #else
                NSWorkspace.shared.open(presenter.link(.github))
                #endif
            } content: {
                HStack {
                    RefdsIcon(symbol: .link, size: 20)
                        .frame(width: 30)
                    RefdsText(presenter.string(.optionGithub))
                }
            }
            
            RefdsRow {
                presenter.requestReview()
            } content: {
                HStack {
                    RefdsIcon(symbol: .heart, size: 20)
                        .frame(width: 30)
                    RefdsText(presenter.string(.optionWriteReview))
                }
            }
            
            RefdsRow {
                presenter.appShareItem = .init(isPresented: true, url: presenter.link(.appleStore))
            } content: {
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
            RefdsText(presenter.string(.applicationName), style: .title1, weight: .bold)
            RefdsText(presenter.string(.applicationAuthor), color: .secondary)
            RefdsTag(presenter.appVersion, style: .subheadline, color: .accentColor)
        }
    }
}
