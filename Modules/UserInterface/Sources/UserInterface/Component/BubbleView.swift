//
//  BubbleView.swift
//  
//
//  Created by Rafael Santos on 08/04/23.
//

import SwiftUI
import RefdsUI
import Domain

public struct BubbleView: View {
    @Binding private var data: [BubbleDataItem]
    private var spacing: CGFloat = 5
    private var startAngle: Int = 180
    private var clockwise: Bool = Bool.random()
    
    public init(viewData: Binding<[BubbleDataItem]>) {
        _data = viewData
    }
    
    struct ViewSize {
        var xMin: CGFloat = 0
        var xMax: CGFloat = 0
        var yMin: CGFloat = 0
        var yMax: CGFloat = 0
    }
    
    @State private var mySize = ViewSize()
    
    public var body: some View {
        let xSize = (mySize.xMax - mySize.xMin) == 0 ? 1 : (mySize.xMax - mySize.xMin)
        let ySize = (mySize.yMax - mySize.yMin) == 0 ? 1 : (mySize.yMax - mySize.yMin)

        GeometryReader { geo in
            let xScale = geo.size.width / xSize
            let yScale = geo.size.height / ySize
            let scale = min(xScale, yScale)
                     
            ZStack {
                ForEach(data.indices, id: \.self) { index in
                    let item = data[index]
                    ZStack {
                        Circle()
                        RefdsText(
                            item.title.uppercased(),
                            size: .custom(CGFloat(item.value) * scale * 0.13),
                            color: .white,
                            weight: .bold
                        )
                    }
                    .frame(width: CGFloat(item.value) * scale,
                           height: CGFloat(item.value) * scale)
                    .foregroundColor(item.color)
                    .offset(x: item.offset.width * scale, y: item.offset.height * scale)
                }
            }
            .offset(x: xOffset() * scale, y: yOffset() * scale)
        }
        .frame(maxWidth: .infinity)
        .onChange(of: data, perform: { _ in
            setOffets()
            mySize = absoluteSize()
        })
        .onAppear {
            setOffets()
            mySize = absoluteSize()
        }
    }
    
    func xOffset() -> CGFloat {
        let size = data[0].value
        let xOffset = mySize.xMin + size / 2
        return -xOffset
    }
    
    func yOffset() -> CGFloat {
        let size = data[0].value
        let yOffset = mySize.yMin + size / 2
        return -yOffset
    }
    
    func setOffets() {
        if data.isEmpty { return }
        data[0].offset = CGSize.zero
        if data.count < 2 { return }
        let b = (data[0].value + data[1].value) / 2 + spacing
        var alpha: CGFloat = CGFloat(startAngle) / 180 * CGFloat.pi
        data[1].offset = CGSize(width: cos(alpha) * b, height: sin(alpha) * b)
        
        for i in 2..<data.count {
            let c = (data[0].value + data[i-1].value) / 2 + spacing
            let b = (data[0].value + data[i].value) / 2 + spacing
            let a = (data[i-1].value + data[i].value) / 2 + spacing
            
            alpha += calculateAlpha(a, b, c) * (clockwise ? 1 : -1)
            
            let x = cos(alpha) * b
            let y = sin(alpha) * b
            
            data[i].offset = CGSize(width: x, height: y )
        }
    }
    
    func calculateAlpha(_ a: CGFloat, _ b: CGFloat, _ c: CGFloat) -> CGFloat {
        return acos((pow(a, 2) - pow(b, 2) - pow(c, 2) ) / (-2 * b * c))
    }
    
    func absoluteSize() -> ViewSize {
        let radius = data[0].value / 2
        let initialSize = ViewSize(xMin: -radius, xMax: radius, yMin: -radius, yMax: radius)
        
        let maxSize = data.reduce(initialSize, { partialResult, item in
            let xMin = min(
                partialResult.xMin,
                item.offset.width - item.value / 2 - spacing
            )
            let xMax = max(
                partialResult.xMax,
                item.offset.width + item.value / 2 + spacing
            )
            let yMin = min(
                partialResult.yMin,
                item.offset.height - item.value / 2 - spacing
            )
            let yMax = max(
                partialResult.yMax,
                item.offset.height + item.value / 2 + spacing
            )
            return ViewSize(xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax)
        })
        return maxSize
    }
}
