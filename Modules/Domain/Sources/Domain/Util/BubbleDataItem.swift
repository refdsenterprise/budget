//
//  BubbleDataItem.swift
//  
//
//  Created by Rafael Santos on 08/04/23.
//

import SwiftUI

public struct BubbleDataItem: Identifiable, Equatable {
    public var id: UUID = .init()
    public var title: String
    public var value: CGFloat
    public var color: Color
    public var offset = CGSize.zero
    public var realValue: Double
    
    public init(title: String, value: CGFloat, color: Color, realValue: Double) {
        self.title = title
        self.value = value
        self.color = color
        self.realValue = realValue
    }
}
