//
//  IndicatorPointView.swift
//  Budget
//
//  Created by Rafael Santos on 08/02/23.
//

import SwiftUI

public struct IndicatorPointView: View {
    var color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Circle().fill(color.opacity(0.5)).frame(width: 20, height: 20)
                Circle().fill(color.opacity(0.8)).frame(width: 10, height: 20)
            }
        }
    }
}

struct IndicatorPointView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPointView(color: .pink)
    }
}
