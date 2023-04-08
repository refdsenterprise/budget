//
//  AppIconView.swift
//  
//
//  Created by Rafael Santos on 30/03/23.
//

import SwiftUI
import RefdsUI

public struct AppIconView: View {
    private let icon: RefdsIconSymbol
    private let color: Color
    
    public init(icon: RefdsIconSymbol = .dollarsign, color: Color = .accentColor) {
        self.icon = icon
        self.color = color
    }
    
    public var body: some View {
        Group {
            RefdsIcon(symbol: icon, color: .white, size: 30, weight: .bold, renderingMode: .hierarchical)
        }
        .frame(width: 90, height: 90)
        .background(
            LinearGradient(colors: [color.opacity(0.7), color], startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(20)
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        Group { AppIconView() }
        Group { AppIconView(icon: .brazilianrealsign, color: .pink) }
    }
}
