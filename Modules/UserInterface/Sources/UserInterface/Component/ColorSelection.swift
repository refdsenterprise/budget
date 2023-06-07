//
//  ColorSelection.swift
//  
//
//  Created by Rafael Santos on 30/05/23.
//

import SwiftUI
import RefdsUI

public struct ColorSelection: View {
    @Binding private var color: RefdsColor
    private var colors: [RefdsColor] = RefdsColor.Default.allCases.map({ $0.rawValue })
    private var axes: Axis.Set
    
    public init(color: Binding<RefdsColor>, axes: Axis.Set = .horizontal) {
        self._color = color
        self.axes = axes
    }
    
    public var body: some View {
        ScrollView(axes, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(colors, id: \.id) { color in
                    RefdsButton { self.color = color } label: {
                        Circle().fill(color).frame(width: 20, height: 20)
                            .scaleEffect(1.5)
                            .overlay(alignment: .center) {
                                if color.asHex() == self.color.asHex() {
                                    Circle().fill(.white.opacity(0.8)).frame(width: 10, height: 10)
                                }
                            }
                    }
                }
            }
            .frame(minHeight: 50)
            .padding(.horizontal)
        }
    }
}

struct ColorSelection_Previews: PreviewProvider {
    @State static var color: Color = .blue
    static var previews: some View {
        ColorSelection(color: $color)
    }
}
