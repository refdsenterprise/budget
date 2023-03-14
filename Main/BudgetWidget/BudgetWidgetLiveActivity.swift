//
//  BudgetWidgetLiveActivity.swift
//  BudgetWidget
//
//  Created by Rafael Santos on 13/03/23.
//

import ActivityKit
import WidgetKit
import SwiftUI
import Presentation
import Charts
import Domain

struct BudgetWidgetLiveActivity: Widget {
    private var presenter: WidgetPresenter = .shared
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BudgetWidgetAttributes.self) { context in
            let diff = presenter.diff
            let totalBudget = presenter.totalBudget
            let diffColor = presenter.diffColor
            let totalActual = presenter.totalActual
            let chartData = presenter.chartData
            systemMedium(diff: diff, totalBudget: totalBudget, totalActual: totalActual, diffColor: diffColor, chartData: chartData)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
    
    private func systemMedium(diff: Double, totalBudget: Double, totalActual: Double, diffColor: Color, chartData: [(label: String, data: [(category: String, value: Double)])]) -> some View {
        ViewThatFits {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 4) {
                            Text("Budget")
                                .font(.system(size: 17, weight: .bold))
                            Text(Date.current.asString(withDateFormat: .custom("MMM")).capitalized)
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Text(totalBudget.currency)
                            .font(.system(size: 12, design: .monospaced))
                    }
                    ProgressView(value: totalActual, total: totalBudget) {
                        HStack(spacing: 5) {
                            Image(systemName: "dollarsign.square.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(diffColor)
                                .scaleEffect(1.1)
                            Text(totalActual.currency)
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .lineLimit(1)
                            
                            
                            Spacer()
                            Text(String(format: "%02d", Int((totalActual * 100) / totalBudget)) + "%")
                                .font(.system(size: 12, weight: .bold))
                            
                        }
                    }
                    .progressViewStyle(.linear)
                    .tint(diffColor)
                }
                sectionChartBar(chartData: chartData, diffColor: diffColor)
            }
            .padding()
        }
    }
    
    private func sectionChartBar(chartData: [(label: String, data: [(category: String, value: Double)])], diffColor: Color) -> some View {
        Chart(chartData, id: \.label) { chartData in
            ForEach(chartData.data, id: \.category) {
                BarMark(
                    x: .value(presenter.string(.category), String($0.category.prefix(3)) + "."),
                    y: .value(presenter.string(.value), $0.value)
                )
                .foregroundStyle(by: .value(presenter.string(.category), chartData.label))
                .position(by: .value(presenter.string(.category), chartData.label))
            }
        }
        .chartForegroundStyleScale([
            presenter.string(.budget): Color.blue,
            presenter.string(.current): diffColor
        ])
        .chartLegend(.hidden)
        .chartYAxis { AxisMarks(position: .trailing) }
        .frame(height: 90)
        .scaledToFill()
        .minimumScaleFactor(0.1)
        .frame(maxWidth: .infinity)
    }
}

struct BudgetWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = BudgetWidgetAttributes(name: "Me")
    static let contentState = BudgetWidgetAttributes.ContentState(value: 3)

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
