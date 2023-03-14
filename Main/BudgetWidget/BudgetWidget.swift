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
            Text("Budget")
                .font(.system(size: 20, weight: .bold))
                .lineLimit(1)
                .padding(.bottom, 5)
            Text(presenter.string(.currentValue(.current)).uppercased())
                .font(.system(size: 8))
                .foregroundColor(.secondary)
                .lineLimit(1)
            Text(totalActual.currency)
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(totalBudget.currency)
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundColor(.green)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.bottom, 5)
            Text(presenter.string(.diff).uppercased())
                .font(.system(size: 10))
        }
        .progressViewStyle(.linear)
        .accentColor(diffColor)
        .padding()
    }
    
    private func systemMedium(diff: Double, totalBudget: Double, totalActual: Double, diffColor: Color, chartData: [(label: String, data: [(category: String, value: Double)])]) -> some View {
        ViewThatFits {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 4) {
                            Text("Budget")
                                .font(.system(size: 17, weight: .bold))
                            Text(entry.date.asString(withDateFormat: .custom("MMM")).capitalized)
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
                sectionChartBar(chartData: chartData)
            }
            .padding()
        }
    }
    
    private func accessoryRectangular(diff: Double, totalBudget: Double, totalActual: Double) -> some View {
        ViewThatFits {
            VStack(alignment: .leading) {
                ProgressView(value: diff, total: totalBudget) {
                    Label(presenter.string(.diff), systemImage: "dollarsign.square.fill")
                        .symbolRenderingMode(.hierarchical)
                        .fontWeight(.bold)
                        .padding(.bottom, 3)
                }
                .progressViewStyle(.linear)
                
                HStack {
                    Text("Atual:")
                    Text(totalActual.currency)
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
        .frame(height: 85)
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
