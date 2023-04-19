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
    
    var body: some View {
        List {
            sectionHeaderIcon
            sectionApplicationTheme
        }
        .navigationTitle(presenter.string(.navigationTitle))
    }
    
    private var sectionApplicationTheme: some View {
        Section {
            ColorPicker(selection: Binding(get: {
                presenter.themeColor
            }, set: {
                presenter.themeColor = $0
                appConfigurator.themeColor = $0
            }), supportsOpacity: true) {
                RefdsText(presenter.string(.color))
            }
            CollapsedView(title: presenter.string(.appearence), description: presenter.appearenceSelected.description) {
                ForEach(AppearenceItem.allCases, id: \.self) { appearence in
                    Button {
                        presenter.appearenceSelected = appearence
                        appConfigurator.colorScheme = appearence.colorScheme
                    } label: {
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
        } header: {
            RefdsText(presenter.string(.theme), size: .extraSmall, color: .secondary)
        }
    }
    
    private var sectionHeaderIcon: some View {
        Section {} footer: {
            VStack {
                AppIconView(icon: .dollarsign, color: appConfigurator.themeColor)
                RefdsText(presenter.string(.appName))
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
        }
    }
}
