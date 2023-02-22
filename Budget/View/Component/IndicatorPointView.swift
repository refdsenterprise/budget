//
//  IndicatorPointView.swift
//  Budget
//
//  Created by Rafael Santos on 08/02/23.
//

import SwiftUI

struct IndicatorPointView: View {
    var color: Color
    var body: some View {
        VStack {
            VStack {
            }
            .frame(width: 10, height: 10)
            .background(color)
            .cornerRadius(3)
        }
        .frame(width: 20, height: 20)
        .background(color.opacity(0.2))
        .cornerRadius(5)
    }
}

struct IndicatorPointView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPointView(color: .pink)
    }
}
