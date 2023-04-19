//
//  CustomizationmacOSView.swift
//  
//
//  Created by Rafael Santos on 17/04/23.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation

struct CustomizationmacOSView<Presenter: CustomizationPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    @EnvironmentObject private var appConfigurator: AppConfiguration
    
    var body: some View {
        MacUIView(maxAmount: 2) {
            Group {
                sectionHeaderIcon
                sectionApplicationTheme
            }
        }
        .navigationTitle(presenter.string(.navigationTitle))
    }
    
    private var sectionApplicationTheme: some View {
        SectionGroup(headerTitle: presenter.string(.theme)) {
            Group {
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
                                Spacer()
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
        }
    }
    
    private var sectionHeaderIcon: some View {
        VStack {
            AppIconView(icon: .dollarsign, color: appConfigurator.themeColor)
            RefdsText(presenter.string(.appName))
        }
        .frame(maxWidth: .infinity)
        .padding(.top)
    }
}

