//
//  CheckBoxStyle.swift
//  
//
//  Created by Rafael Santos on 04/03/23.
//

import SwiftUI

public struct CheckBoxStyle: ToggleStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation {
                configuration.isOn.toggle()
            }
        } label: {
            HStack {
                configuration.label
                Spacer()
                IndicatorPointView(color: configuration.isOn ? .accentColor : .secondary)
                    .scaleEffect(configuration.isOn ? 1 : 0.8)
                    .animation(.easeInOut.repeatCount(1, autoreverses: true), value: configuration.isOn)
            }
        }
    }
}
