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

struct Provider: IntentTimelineProvider {
    static var presenter: WidgetPresenter = .shared
    
    func placeholder(in context: Context) -> CurrencyEntry {
        CurrencyEntry(date: .current, totalBudget: 0, totalActual: 0)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (CurrencyEntry) -> ()) {
        let entry = CurrencyEntry(
            date: .current,
            totalBudget: Self.presenter.totalBudget,
            totalActual: Self.presenter.totalActual
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [CurrencyEntry] = [
            .init(
                date: .current,
                totalBudget: Self.presenter.totalBudget,
                totalActual: Self.presenter.totalActual
            )
        ]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct CurrencyEntry: TimelineEntry {
    var date: Date
    let totalBudget: Double
    let totalActual: Double
}

struct BudgetWidgetEntryView : View {
    @Environment(\.widgetFamily) var size
    private var presenter = WidgetPresenter.shared
    var entry: Provider.Entry
    
    public init(entry: Provider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        switch size {
        case .accessoryRectangular: accessoryRectangular
        case .systemSmall: systemSmall
        case .accessoryCircular: accessoryCircular
        case .accessoryInline: accessoryInline
        default: HStack{}
        }
    }

    private var systemSmall: some View {
        ProgressView(value: presenter.diff, total: presenter.totalBudget) {
            Text("Budget")
                .font(.system(size: 20, weight: .bold))
                .lineLimit(1)
                .padding(.bottom, 5)
            Text(presenter.string(.currentValue(.current)).uppercased())
                .font(.system(size: 8))
                .foregroundColor(.secondary)
                .lineLimit(1)
            Text(presenter.totalActual.currency)
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(presenter.totalBudget.currency)
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundColor(.green)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.bottom, 5)
            Text(presenter.string(.diff).uppercased())
                .font(.system(size: 10))
        }
        .progressViewStyle(.linear)
        .accentColor(presenter.diffColor)
        .padding()
    }
    
    private var accessoryRectangular: some View {
        ViewThatFits {
            VStack(alignment: .leading) {
                ProgressView(value: presenter.diff, total: presenter.totalBudget) {
                    Label(presenter.string(.diff), systemImage: "dollarsign.square.fill")
                        .symbolRenderingMode(.hierarchical)
                        .fontWeight(.bold)
                        .padding(.bottom, 3)
                }
                .progressViewStyle(.linear)
                
                HStack {
                    Text("Atual:")
                    Text(presenter.totalActual.currency)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
    }
    
    private var accessoryCircular: some View {
        ViewThatFits {
            ProgressView(value: presenter.diff, total: presenter.totalBudget) {
                Image(systemName: "dollarsign.square.fill")
                    .symbolRenderingMode(.hierarchical)
                    .scaleEffect(0.9)
            }
            .progressViewStyle(.circular)
        }
    }
    
    private var accessoryInline: some View {
        ViewThatFits {
            Label {
                Text("Resta \((presenter.totalBudget - presenter.totalActual).currency)")
            } icon: {
                Image(systemName: "dollarsign.square.fill")
                    .symbolRenderingMode(.hierarchical)
                    .scaleEffect(1.1)
            }
        }
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
            .accessoryInline
        ])
    }
}

struct BudgetWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        BudgetWidgetEntryView(entry: .init(date: .current, totalBudget: 540, totalActual: 12000))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        
        BudgetWidgetEntryView(entry: .init(date: .current, totalBudget: 540, totalActual: 12000))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
