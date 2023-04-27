//
//  ProTag.swift
//  
//
//  Created by Rafael Santos on 20/04/23.
//

import SwiftUI
import RefdsUI
import Presentation

public struct ProTag: View {
    @State private var isPresentedPro: Bool = false
    
    public init() {}
    
    public var body: some View {
        if Device.current == .macOS {
            proTag
                .navigation(isPresented: $isPresentedPro) {
                    ProScreen<ProPresenter>(presenter: .shared)
                }
        } else {
            proTag
                .sheet(isPresented: $isPresentedPro) {
                    ProScreen<ProPresenter>(presenter: .shared)
                }
        }
    }
    
    private var proTag: some View {
        Button { isPresentedPro.toggle() } label: {
            RefdsTag("PRO", color: .yellow)
        }
    }
}

struct ProTag_Previews: PreviewProvider {
    static var previews: some View {
        ProTag()
    }
}
