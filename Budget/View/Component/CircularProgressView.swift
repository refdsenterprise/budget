//
//  CircularProgressView.swift
//  Budget
//
//  Created by Rafael Santos on 10/02/23.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    init(progress: Double, color: Color = .accentColor) {
        self.progress = progress
        self.color = color
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(
                                color.opacity(0.5),
                                lineWidth: proxy.size.height * 0.2
                            )
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                color,
                                style: StrokeStyle(
                                    lineWidth: proxy.size.height * 0.2,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut, value: progress)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.4)
            .frame(height: 80)
    }
}
