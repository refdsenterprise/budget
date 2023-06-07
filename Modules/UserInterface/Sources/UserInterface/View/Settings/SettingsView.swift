//
//  SettingsView.swift
//  
//
//  Created by Rafael Santos on 27/03/23.
//

import SwiftUI
import RefdsUI
import Presentation
import Resource

struct SettingsView<Presenter: SettingsPresenterProtocol>: View {
    @EnvironmentObject private var configuration: AppConfiguration
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        RefdsList {
            sectionConfiguration(proxy: $0)
            sectionCustomization(proxy: $0)
            sectionAuth(proxy: $0)
            if presenter.needShowModalPro { ProSection() }
            sectionApplication(proxy: $0)
        }
        .navigationTitle(presenter.string(.navigationTitle))
        .onAppear { presenter.loadData() }
    }
    
    private func sectionConfiguration(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy, headerDescription: presenter.string(.headerConfiguration)) {
            if presenter.needShowModalPro {
                rowNotifications
            } else {
                RefdsRow { rowNotifications } destination: {
                    presenter.router.configure(routes: .notification)
                }
            }
        }
    }
    
    private func sectionCustomization(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy, headerDescription: presenter.string(.manageCustomization)) {
            if presenter.needShowModalPro {
                rowCustomization
                rowCustomAppIcon
            } else {
                RefdsRow { rowCustomization } destination: {
                    presenter.router.configure(routes: .customization)
                }
                
                RefdsRow { rowCustomAppIcon } destination: {
                    presenter.router.configure(routes: .customAppIcon)
                }
            }
        }
    }
    
    private func sectionAuth(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy) {
            rowFaceID
            RefdsRow { configuration.onboarding.toggle() } content: {
                rowOnboarding
            }
            RefdsRow { presenter.openSystemPermissions() } content: {
                rowPermissions
            }
        }
    }
    
    private func sectionApplication(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy) {
            RefdsRow { rowAbout } destination: {
                presenter.router.configure(routes: .about)
            }
        }
    }
    
    private var rowNotifications: some View {
        rowLabel(
            presenter.string(.manageNotification),
            icon: .bellFill,
            color: .red,
            needPro: presenter.needShowModalPro
        )
    }
    
    private var rowCustomization: some View {
        rowLabel(
            presenter.string(.manageCustomization),
            icon: .heartFill,
            color: .pink,
            needPro: presenter.needShowModalPro
        )
    }
    
    private var rowAbout: some View {
        rowLabel(
            presenter.string(.aboutApplication),
            icon: .info,
            color: .green
        )
    }
    
    private var rowFaceID: some View {
        rowLabelRefdsToggle(
            presenter.string(.faceIDPasscode),
            icon: .faceid,
            color: .blue,
            isOn: $configuration.allowAuth,
            needPro: presenter.needShowModalPro
        )
    }
    
    private var rowOnboarding: some View {
        rowLabel(
            Strings.Onboarding.onboarding.value,
            icon: .squareTextSquareFill,
            color: .orange
        )
    }
    
    private var rowCustomAppIcon: some View {
        rowLabel(
            presenter.string(.customAppIcon),
            icon: .squareDashedInsetFilled,
            color: .teal,
            needPro: presenter.needShowModalPro
        )
    }
    
    private var rowPermissions: some View {
        rowLabel(
            presenter.string(.sytemPermissions),
            icon: .gearshapeCircleFill,
            color: .secondaryLabel
        )
    }
    
    @ViewBuilder
    private func rowLabelRefdsToggle(
        _ title: String,
        icon: RefdsIconSymbol,
        color: RefdsColor.Default,
        isOn: Binding<Bool>,
        needPro: Bool = false
    ) -> some View {
        if needPro {
            HStack {
                iconSquare(icon, color: color)
                RefdsText(title)
                Spacer()
                ProTag()
            }
        } else {
            RefdsToggle(isOn: isOn) {
                HStack {
                    iconSquare(icon, color: color)
                    RefdsText(title)
                    Spacer()
                }
            }
        }
    }
    
    private func rowLabel(
        _ title: String,
        icon: RefdsIconSymbol,
        color: RefdsColor.Default,
        needPro: Bool = false
    ) -> some View {
        HStack {
            iconSquare(icon, color: color)
            RefdsText(title)
            Spacer()
            if needPro { ProTag() }
        }
    }
    
    private func iconSquare(_ icon: RefdsIconSymbol, color: RefdsColor.Default) -> some View {
        RefdsIcon(symbol: icon, color: .white, size: 15, renderingMode: .hierarchical)
            .frame(width: 28, height: 28)
            .background(color.rawValue)
            .cornerRadius(5)
            .padding(.vertical, 4)
            .padding(.trailing, 12)
    }
}
