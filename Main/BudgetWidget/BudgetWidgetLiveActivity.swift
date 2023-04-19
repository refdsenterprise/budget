//
//  BudgetWidgetLiveActivity.swift
//  BudgetWidget
//
//  Created by Rafael Santos on 13/03/23.
//

#if targetEnvironment(macCatalyst)
#else
import ActivityKit
import WidgetKit
import SwiftUI
import Presentation
import Charts
import Domain

struct BudgetWidgetLiveActivity: Widget {
    @Environment(\.colorScheme) var colorScheme
    private var presenter: WidgetPresenter = .shared
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BudgetWidgetAttributes.self) { context in
            let diff = presenter.diff
            let totalBudget = presenter.totalBudget
            let diffColor = presenter.diffColor
            let totalActual = presenter.totalActual
            let chartData = presenter.chartData
            let isEmpty = presenter.isEmpty
            let isActive = presenter.isActive
            systemMedium(diff: diff, totalBudget: totalBudget, totalActual: totalActual, diffColor: diffColor, chartData: chartData, isEmpty: isEmpty || !isActive)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            (
                                Text("Budget ") +
                                Text(Date.current.asString(withDateFormat: .custom("MMM")).capitalized)
                                    .foregroundColor(.secondary)
                            )
                            .font(.system(size: 14, weight: .bold))
                            Text(presenter.totalBudget.currency)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.leading, 5)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .leading) {
                        Text(presenter.totalActual.currency)
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                        (
                            Text(String(format: "%d", Int(100 - presenter.diff)) + "%")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(presenter.diffColor)
                             +
                            Text("  Restante")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        )
                    }
                    .padding(.trailing, 5)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        ProgressView(value: presenter.totalActual, total: presenter.totalBudget)
                            .progressViewStyle(.linear)
                            .tint(presenter.diffColor)
                            .scaleEffect(2)
                            .padding(.horizontal, 86)
                        Spacer()
                        sectionChartBar(chartData: presenter.chartData, diffColor: presenter.diffColor, isLarge: false)
                    }
                }
            } compactLeading: {
                Text(presenter.totalActual.currency)
                    .fontWeight(.bold)
                    .fontDesign(.monospaced)
            } compactTrailing: {
                (
                    Text("Resta ") +
                    Text(String(format: "%d", Int(100 - presenter.diff)) + "%")
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                        .foregroundColor(presenter.diffColor)
                )
            } minimal: {
                accessoryCircular(diff: presenter.diff, totalBudget: presenter.totalBudget)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
    
    private func accessoryCircular(diff: Double, totalBudget: Double) -> some View {
        ProgressView(value: diff, total: totalBudget) {
            Text(String(format: "%d", Int(diff)))
        }
        .progressViewStyle(.circular)
        .frame(height: 23)
    }
    
    private var systemMediumEmpty: some View {
        ViewThatFits {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    HStack {
                        Image(systemName: "dollarsign.square.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.green)
                            .scaleEffect(1.5)
                        Text("Budget")
                            .font(.system(size: 17, weight: .bold))
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Button(action: {}) {
                            Text((presenter.isActive ? "planejar" : "seja pro").uppercased())
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: 100)
                        .padding(.all, 8)
                        .background(Color.green)
                        .cornerRadius(6)
                    }
                }
                Spacer()
                Text(presenter.isActive ? "Até o momento, nenhum orçamento para o mês de \(Date.current.asString(withDateFormat: .custom("MMMM"))) foi realizado. Clique aqui e comece seu mês planejando sua vida financeira." : "Para utilizar os widget é necessário ser PRO. Com isso, você terá acesso a todos os relatórios e diversos recursos especiais.")
                    .frame(height: 60)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
        }
    }
    
    private func systemMedium(diff: Double, totalBudget: Double, totalActual: Double, diffColor: Color, chartData: [ChartDataItem], isEmpty: Bool) -> some View {
        ViewThatFits {
            if isEmpty {
                systemMediumEmpty
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        HStack {
                            Image(systemName: "dollarsign.square.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(diffColor)
                                .scaleEffect(1.5)
                            VStack(alignment: .leading) {
                                (
                                    Text("Budget ") +
                                    Text(Date.current.asString(withDateFormat: .custom("MMM")).capitalized)
                                        .foregroundColor(.secondary)
                                )
                                .font(.system(size: 17, weight: .bold))
                                Text(totalBudget.currency)
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(.secondary)
                            }
                        }
                        ProgressView(value: totalActual, total: totalBudget) {
                            HStack(spacing: 5) {
                                Text(totalActual.currency)
                                    .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                                    .lineLimit(1)
                                
                                Spacer()
                                Text(String(format: "%02d", Int((totalActual * 100) / totalBudget)) + "%")
                                    .font(.system(size: 8.5))
                                
                            }
                        }
                        .scaleEffect(1.5)
                        .progressViewStyle(.linear)
                        .tint(diffColor)
                        .padding()
                        .padding(.horizontal, 15)
                        .padding(.leading, 3)
                    }
                    sectionChartBar(chartData: chartData, diffColor: diffColor, isLarge: true)
                }
                .padding()
            }
        }
    }
    
    private func sectionChartBar(chartData: [ChartDataItem], diffColor: Color, isLarge: Bool) -> some View {
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
        .frame(height: isLarge ? 90 : 60)
        .scaledToFill()
        .minimumScaleFactor(0.1)
        .frame(maxWidth: .infinity)
    }
}

struct BudgetWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = BudgetWidgetAttributes(name: "Me")
    static let presenter = WidgetPresenter.shared
    static let contentState = BudgetWidgetAttributes.ContentState(
        diff: presenter.diff,
        totalBudget: presenter.totalBudget,
        diffColor: presenter.diffColor,
        totalActual: presenter.totalActual,
        chartData: presenter.chartData,
        isEmpty: presenter.isEmpty,
        isActive: presenter.isActive
    )

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
#endif
