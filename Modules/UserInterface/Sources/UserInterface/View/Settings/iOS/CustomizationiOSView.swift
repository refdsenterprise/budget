//
//  CustomizationiOSView.swift
//  
//
//  Created by Rafael Santos on 08/04/23.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation

struct CustomizationiOSView<Presenter: CustomizationPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    @EnvironmentObject private var appConfigurator: AppConfiguration
    @State private var isCollapsed: Bool = true
    
    var body: some View {
        RefdsList {
            sectionHeaderIcon(proxy: $0)
            sectionColor(proxy: $0)
            sectionScheme(proxy: $0)
        }
        .navigationTitle(presenter.string(.navigationTitle))
    }
    
    private func sectionHeaderIcon(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy, header: nil) {
            VStack {
                AppIconView(icon: .dollarsign, color: appConfigurator.themeColor)
                RefdsText(presenter.string(.appName))
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
        } content: {}
    }
    
    private func sectionColor(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy, headerDescription: presenter.string(.color)) {
            ColorSelection(color: Binding(get: {
                presenter.themeColor
            }, set: {
                presenter.themeColor = $0
                appConfigurator.themeColor = $0
            }))
        }
    }
    
    private func sectionScheme(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy, headerDescription: presenter.string(.theme)) {
            ForEach(AppearenceItem.allCases, id: \.self) { appearence in
                RefdsRow {
                    presenter.appearenceSelected = appearence
                    appConfigurator.colorScheme = appearence.colorScheme
                } content: {
                    HStack(spacing: 15) {
                        RefdsIcon(symbol: appearence.icon, color: presenter.appearenceSelected == appearence ? appConfigurator.themeColor : .primary, size: 20, renderingMode: .hierarchical)
                            .padding(.all, 5)
                            .background((presenter.appearenceSelected == appearence ? appConfigurator.themeColor : .secondary).opacity(0.2))
                            .cornerRadius(8)
                        RefdsText(appearence.description)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }
}
