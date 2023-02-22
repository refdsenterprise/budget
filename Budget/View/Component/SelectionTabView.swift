//
//  SelectionTabView.swift
//  Budget
//
//  Created by Rafael Santos on 21/02/23.
//

import SwiftUI
import RefdsUI

struct SelectionTabView: View {
    var values: [String]
    @Binding var selected: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(values.indices, id: \.self) { index in
                    Button {
                        selected = values[index]
                    } label: {
                        RefdsTag(values[index], size: .custom(14), color: values[index] == selected ? .accentColor : .secondary, lineLimit: 1)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SelectionTabView_Previews: PreviewProvider {
    static var previews: some View {
        let values = ["segunda-feira", "sábado", "quarta-feira", "terça-feira", "domingo", "quinta-feira"]
        var value = values.randomElement()!
        SelectionTabView(values: values, selected: Binding(get: { value }, set: { value = $0 }))
    }
}
