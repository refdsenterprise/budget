//
//  BudgetWidget.swift
//  BudgetWidget
//
//  Created by Rafael Santos on 13/03/23.
//

import WidgetKit
import SwiftUI
import RefdsUI
import Presentation
import Intents
import UserInterface
import Charts

struct Provider: IntentTimelineProvider {
    static var presenter: WidgetPresenter = .shared
    
    func placeholder(in context: Context) -> CurrencyEntry {
        CurrencyEntry(
            date: .current,
            diff: Self.presenter.diff,
            totalBudget: Self.presenter.totalBudget,
            diffColor: Self.presenter.diffColor,
            totalActual: Self.presenter.totalActual,
            chartData: Self.presenter.chartData
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CurrencyEntry) -> ()) {
        let entry = CurrencyEntry(
            date: .current,
            diff: Self.presenter.diff,
            totalBudget: Self.presenter.totalBudget,
            diffColor: Self.presenter.diffColor,
            totalActual: Self.presenter.totalActual,
            chartData: Self.presenter.chartData
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [CurrencyEntry] = [
            CurrencyEntry(
                date: .current,
                diff: Self.presenter.diff,
                totalBudget: Self.presenter.totalBudget,
                diffColor: Self.presenter.diffColor,
                totalActual: Self.presenter.totalActual,
                chartData: Self.presenter.chartData
            )
        ]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct CurrencyEntry: TimelineEntry {
    var date: Date
    let diff: Double
    let totalBudget: Double
    let diffColor: Color
    let totalActual: Double
    let chartData: [(label: String, data: [(category: String, value: Double)])]
}

struct BudgetWidgetEntryView : View {
    @Environment(\.widgetFamily) var size
    private var presenter = WidgetPresenter.shared
    var entry: Provider.Entry
    
    public init(entry: Provider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        let diff = entry.diff
        let totalBudget = entry.totalBudget
        let diffColor = entry.diffColor
        let totalActual = entry.totalActual
        let chartData = entry.chartData
        
        switch size {
        case .systemSmall: systemSmall(diff: diff, totalBudget: totalBudget, totalActual: totalActual, diffColor: diffColor)
        case .systemMedium: systemMedium(diff: diff, totalBudget: totalBudget, totalActual: totalActual, diffColor: diffColor, chartData: chartData)
        case .accessoryInline: accessoryInline(diff: diff)
        case .accessoryRectangular: accessoryRectangular(diff: diff, totalBudget: totalBudget, totalActual: totalActual)
        case .accessoryCircular: accessoryCircular(diff: diff, totalBudget: totalBudget)
        default: HStack{}
        }
    }

    private func systemSmall(diff: Double, totalBudget: Double, totalActual: Double, diffColor: Color) -> some View {
        ProgressView(value: totalActual, total: totalBudget) {
            VStack(alignment: .leading) {
                Label {
                    (
                        Text("Budget ") +
                        Text(entry.date.asString(withDateFormat: .custom("MMM")).capitalized)
                            .foregroundColor(.secondary)
                    )
                    .font(.system(size: 20, weight: .bold))
                    .minimumScaleFactor(0.5)
                } icon: {
                    Image(systemName: "dollarsign.square.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(diffColor)
                        .scaleEffect(1.3)
                }
                
                Spacer()
                Text("valor atual".uppercased())
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Text(totalActual.currency)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(diffColor)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text(totalBudget.currency)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text("valor budget".uppercased())
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Spacer()
                HStack(spacing: 5) {
                    Text(presenter.string(.diff).uppercased())
                        .font(.system(size: 10, weight: .bold))
                    Text("restante".uppercased())
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .progressViewStyle(.linear)
        .accentColor(diffColor)
        .padding()
    }
    
    private func systemMedium(diff: Double, totalBudget: Double, totalActual: Double, diffColor: Color, chartData: [(label: String, data: [(category: String, value: Double)])]) -> some View {
        ViewThatFits {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    HStack {
                        Image(systemName: "dollarsign.square.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(diffColor)
                            .scaleEffect(1.3)
                        VStack(alignment: .leading) {
                            (
                                Text("Budget ") +
                                Text(entry.date.asString(withDateFormat: .custom("MMM")).capitalized)
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
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .lineLimit(1)
                            
                            Spacer()
                            Text(String(format: "%02d", Int((totalActual * 100) / totalBudget)) + "%")
                                .font(.system(size: 10))
                            
                        }
                        .padding(.bottom, 2)
                    }
                    .scaleEffect(1.3)
                    .progressViewStyle(.linear)
                    .tint(diffColor)
                    .padding()
                    .padding(.horizontal, 3)
                    .padding(.leading, 3)
                }
                sectionChartBar(chartData: chartData)
            }
            .padding()
        }
    }
    
    
    
    private func accessoryRectangular(diff: Double, totalBudget: Double, totalActual: Double) -> some View {
        ViewThatFits {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "dollarsign.square.fill")
                        .symbolRenderingMode(.hierarchical)
                        .fontWeight(.bold)
                        .scaleEffect(1.2)
                    Text(presenter.string(.diff) + " Restante")
                        .fontWeight(.bold)
                }
                
                ProgressView(value: totalActual, total: totalBudget)
                .progressViewStyle(.linear)
                .scaleEffect(1.5)
                .padding(.horizontal, 25)
                
                HStack {
                    Text("Valor:")
                    Text((totalBudget - totalActual).currency)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
    }
    
    private func accessoryCircular(diff: Double, totalBudget: Double) -> some View {
        ViewThatFits {
            ProgressView(value: diff, total: totalBudget) {
                Image(systemName: "dollarsign.square.fill")
                    .symbolRenderingMode(.hierarchical)
                    .scaleEffect(0.9)
            }
            .progressViewStyle(.circular)
        }
    }
    
    private func accessoryInline(diff: Double) -> some View {
        ViewThatFits {
            Label {
                Text("Resta \((diff).currency)")
            } icon: {
                Image(systemName: "dollarsign.square.fill")
                    .symbolRenderingMode(.hierarchical)
                    .scaleEffect(1.1)
            }
        }
    }
    
    private func sectionChartBar(chartData: [(label: String, data: [(category: String, value: Double)])]) -> some View {
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
            presenter.string(.current): entry.diffColor
        ])
        .chartLegend(.hidden)
        .chartYAxis { AxisMarks(position: .trailing) }
        .frame(height: 90)
        .scaledToFill()
        .minimumScaleFactor(0.1)
        .frame(maxWidth: .infinity)
    }
}

struct BudgetWidget: Widget {
    let kind: String = "BudgetWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BudgetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Budget")
        .description("Acompanhe suas dispesas sabendo até quanto pode gastar")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryRectangular,
            .accessoryCircular,
            .accessoryInline,
        ])
    }
}

struct BudgetWidget_Previews: PreviewProvider {
    static var previews: some View {
        BudgetWidgetEntryView(entry: .init(
            date: .current,
            diff: 30,
            totalBudget: 50,
            diffColor: .teal,
            totalActual: 20,
            chartData: []
        ))
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        
        BudgetWidgetEntryView(entry: .init(
            date: .current,
            diff: 30,
            totalBudget: 50,
            diffColor: .teal,
            totalActual: 20,
            chartData: []
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
