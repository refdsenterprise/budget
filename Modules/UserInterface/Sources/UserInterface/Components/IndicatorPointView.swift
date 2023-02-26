//
//  IndicatorPointView.swift
//  Budget
//
//  Created by Rafael Santos on 08/02/23.
//

import SwiftUI

public struct IndicatorPointView: View {
    @State private var animate: Bool = false
    var color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Circle().fill(color.opacity(0.5)).frame(width: 20, height: 20).scaleEffect(animate ? 1 : 0.8)
                Circle().fill(color.opacity(0.8)).frame(width: 10, height: 20)
            }
        }
        .onAppear { animate.toggle() }
        .animation(animate ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: animate)
    }
}

struct IndicatorPointView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPointView(color: .pink)
    }
}
