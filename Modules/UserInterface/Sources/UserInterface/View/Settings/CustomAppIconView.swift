//
//  CustomAppIcon.swift
//  
//
//  Created by Rafael Santos on 02/06/23.
//

import SwiftUI
import RefdsUI
import Presentation
import Resource

public struct CustomAppIconView<Presenter: CustomAppIconPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    public var body: some View {
        RefdsList {
            sectionAppIcon(proxy: $0)
            sectionIcons(proxy: $0)
        }
        .refdsAlert(viewData: $presenter.alert)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
    
    private func sectionAppIcon(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy) {
            HStack {
                Spacer()
                appIcon(presenter.iconSelection, size: 100)
                    .refdsShadow(y: 15)
                    .refdsParallax(magnitude: 10)
                Spacer()
            }
        } content: {}
    }

    private func sectionIcons(proxy: GeometryProxy) -> some View {
        RefdsSection(proxy: proxy) {
            ForEach(ResourceImage.CustomAppIcon.allCases.indices, id: \.self) { index in
                let customAppIcon = ResourceImage.CustomAppIcon.allCases[index]
                RefdsRow {
                    presenter.iconSelection = customAppIcon
                    presenter.changeIcon()
                } content: {
                    HStack(spacing: 15) {
                        appIcon(customAppIcon, size: 45)
                            .refdsShadow(radius: 15, y: 3)
                        RefdsText(customAppIcon.title)
                    }
                }
            }
        }
    }
    
    private func appIcon(_ icon: ResourceImage.CustomAppIcon, size: CGFloat) -> some View {
        icon.image
            .resizable()
            .frame(width: size, height: size)
            .cornerRadius(size / 4)
            .padding(.vertical, 5)
    }
}

struct CustomAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAppIconView<CustomAppIconPresenter>()
            .environmentObject(CustomAppIconPresenter())
    }
}
