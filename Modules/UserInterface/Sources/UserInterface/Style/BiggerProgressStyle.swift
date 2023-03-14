//
//  BiggerProgressStyle.swift
//  
//
//  Created by Rafael Santos on 13/03/23.
//

import SwiftUI

public struct MyProgressViewStyle: ProgressViewStyle {
    private var color: Color
    private var height: CGFloat
    
    public init(color: Color, height: CGFloat) {
        self.color = color
        self.height = height
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .accentColor(color)
            .frame(height: height)
            .scaleEffect(x: 1, y: 2, anchor: .center)
            .clipShape(RoundedRectangle(cornerRadius: height / 2))
            .padding(.horizontal)
    }
}
