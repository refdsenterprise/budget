//
//  NotificationmacOSView.swift
//  
//
//  Created by Rafael Santos on 17/04/23.
//

import SwiftUI
import RefdsUI
import Presentation

struct NotificationmacOSView<Presenter: NotificationManagerPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        Group {
            switch presenter.viewState {
            case .unallowed: sectionUnallowedNotification
            case .hideOptions: sectionNotificationHideOptions
            case .showOptions:
                RefdsList { proxy in
                    sectionAllowNotification(proxy: proxy)
                    sectionNotificationShowOptions(proxy: proxy)
                }
            }
        }
        .navigationTitle(presenter.string(.navigationTitle))
        #if os(iOS)
        .onReceive(SwiftUI.NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task { await presenter.checkNotificationPermission() }
        }
        #endif
    }
    
    private func sectionAllowNotification(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy, maxColumns: 1, headerDescription: presenter.string(.status)) {
            RefdsRow {
                RefdsToggle(isOn: $presenter.isAllowNotification) {
                    HStack {
                        RefdsText(presenter.string(.allowNotification))
                        Spacer()
                    }
                }
                .tint(.accentColor)
            }
        }
    }
    
    private var sectionUnallowedNotification: some View {
        VStack(alignment: .center, spacing: 30) {
            RefdsIcon(symbol: .bellBadgeFill, color: .accentColor, size: 70, renderingMode: .hierarchical)
            VStack(alignment: .center, spacing: 10) {
                RefdsText(presenter.string(.disableNotificationTitle), style: .body, weight: .bold, alignment: .center)
                RefdsText(presenter.string(.disableNotificationDescription), color: .secondary, alignment: .center)
            }
            RefdsButton {
                presenter.actionNotificationSettings()
            } label: {
                RefdsText(presenter.string(.changeNotificationPermission).uppercased(), style: .footnote, color: .white, weight: .bold)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }

        }
        .padding()
        .frame(maxWidth: 450)
    }
    
    private var sectionNotificationHideOptions: some View {
        VStack(alignment: .center, spacing: 30) {
            RefdsIcon(symbol: .bellAndWavesLeftAndRightFill, color: .accentColor, size: 70, renderingMode: .hierarchical)
            VStack(alignment: .center, spacing: 10) {
                RefdsText(presenter.string(.allowNotificationDescription), color: .secondary, alignment: .center)
            }
            RefdsButton {
                presenter.isAllowNotification.toggle()
            } label: {
                RefdsText(presenter.string(.activeNotifications).uppercased(), style: .footnote, color: .white, weight: .bold)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }

        }
        .padding()
        .frame(maxWidth: 450)
    }
    
    private func sectionNotificationShowOptions(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy, headerDescription: presenter.string(.options)) {
            ForEach(presenter.viewData.indices, id: \.self) { index in
                rowNotificationOption(index: index)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func rowNotificationOption(index: Int) -> some View {
        RefdsToggle(isOn: $presenter.viewData[index].isOn) {
            HStack(spacing: 10) {
                Image(systemName: presenter.viewData[index].icon)
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 22, weight: .bold))
                VStack(alignment: .leading, spacing: 5) {
                    RefdsText(presenter.viewData[index].title.capitalized, style: .body, weight: .bold)
                    RefdsText(presenter.viewData[index].description, color: .secondary)
                    Spacer(minLength: 0)
                }
                
                Spacer()
            }
        }
    }
}
