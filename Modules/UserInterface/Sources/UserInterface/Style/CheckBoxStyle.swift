//
//  CheckBoxStyle.swift
//  
//
//  Created by Rafael Santos on 04/03/23.
//

import SwiftUI

public struct CheckBoxStyle: ToggleStyle {
    private let isLeading: Bool
    
    public init(isLeading: Bool = false) {
        self.isLeading = isLeading
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation {
                configuration.isOn.toggle()
            }
        } label: {
            HStack(spacing: 15) {
                if isLeading {
                    IndicatorPointView(color: configuration.isOn ? .accentColor : .secondary)
                        .scaleEffect(configuration.isOn ? 1 : 0.8)
                        .animation(.easeInOut.repeatCount(1, autoreverses: true), value: configuration.isOn)
                    configuration.label
                    Spacer(minLength: 0)
                } else {
                    configuration.label
                    Spacer()
                    IndicatorPointView(color: configuration.isOn ? .accentColor : .secondary)
                        .scaleEffect(configuration.isOn ? 1 : 0.8)
                        .animation(.easeInOut.repeatCount(1, autoreverses: true), value: configuration.isOn)
                }
            }
        }
    }
}
